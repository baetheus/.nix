import * as esbuild from "esbuild";
import * as R from "pick/router";
import { vanillaExtractPlugin } from "@vanilla-extract/esbuild-plugin";
import { serveDir, serveFile } from "@std/http/file-server";
import { denoPlugin } from "@deno/esbuild-plugin";
import { pipe } from "fun/fn";

export async function spaBuild(devMode = false) {
  const ctx = await esbuild.context({
    format: "esm",
    sourcemap: "linked",
    tsconfig: "./deno.json",
    entryPoints: ["./client/main.ts"],
    outdir: "./public",
    bundle: true,
    minify: true,
    treeShaking: true,
    plugins: [
      vanillaExtractPlugin(),
      denoPlugin(),
    ],
    define: { DEV_MODE: String(devMode) },
  });

  return [ctx, devMode ? await ctx.watch() : await ctx.rebuild()] as const;
}

// TODO: serveDir in std/http is pretty overloaded. We could probably copy and
// rewrite it to be much more efficient and not implement dir listing.
export const spaRouter = pipe(
  R.router<unknown>(),
  R.respond(
    "GET /*",
    async ({ request }) => {
      const response = await serveDir(request, {
        fsRoot: "./public",
        quiet: true,
      });
      return response.status < 400
        ? response
        : serveFile(request, "./public/index.html");
    },
  ),
);
