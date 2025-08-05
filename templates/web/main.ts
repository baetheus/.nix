import * as R from "pick/router";
import { createLogRouter } from "pick/logger";
import { pipe } from "fun/fn";

import { spaBuild, spaRouter } from "~/client/serve.ts";
import { apiRouter } from "~/server/serve.ts";

function joinRouter<S>(
  second: R.Router<S>,
): <T>(first: R.Router<T>) => R.Router<S & T> {
  return (first) => [...first, ...second];
}

await spaBuild(true);

const handler = pipe(
  R.router(),
  joinRouter(apiRouter),
  joinRouter(spaRouter),
  createLogRouter(),
  R.withState(null),
);

const server = Deno.serve(handler);
console.log(`Server started on port ${server.addr.port}`);
