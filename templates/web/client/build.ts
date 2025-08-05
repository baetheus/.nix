import esbuild from "esbuild";
import { vanillaExtractPlugin } from "@vanilla-extract/esbuild-plugin";
import { denoPlugin } from "@deno/esbuild-plugin";

// Build Webapp
await esbuild.build({
  format: "esm",
  sourcemap: "linked",
  tsconfig: "./deno.json",
  entryPoints: ["./client/main.ts"],
  outdir: "./public",
  metafile: true,
  bundle: true,
  minify: true,
  treeShaking: true,
  splitting: true,
  plugins: [
    vanillaExtractPlugin(),
    denoPlugin(),
  ],
});
await esbuild.stop();
