import * as R from "pick/router";
import * as X from "pick/response";
import { pipe } from "fun/fn";

export const apiRouter = pipe(
  R.router(),
  R.respond("GET /api/hello", () => X.json({ hello: "world" })),
);
