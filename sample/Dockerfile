FROM node:20.17-bookworm-slim@sha256:df85129996d6b7a4ec702ebf2142cfa683f28b1d33446faec12168d122d3410d as base

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
ENTRYPOINT ["dumb-init", "--"]

###

FROM node:20.17-bookworm-slim@sha256:48db4f6ea21d134be744207225753a1730c4bc1b4cdf836d44511c36bf0e34d7 as install

WORKDIR /usr/src/app

ENV PNPM_HOME="/pnpm"
ENV PNPM_VERSION=9.11.0
ENV PATH="$PNPM_HOME:$PATH"
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -

COPY package.json pnpm-lock.yaml ./

###

FROM install as dependencies

ENV NODE_ENV production
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

###

FROM install as build

# Explicitly preserve src dir hierarchy to resolve TS18003 during the build phase
COPY src/ ./src/
COPY tsconfig.json tsconfig.tsbuildinfo ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build

###

FROM base AS configure

WORKDIR /usr/src/app
COPY --chown=node:node --from=dependencies /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist

###

FROM configure AS run

ENV NODE_ENV production
USER node
CMD [ "node", "dist/index.js" ]
