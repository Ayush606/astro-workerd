using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
  services = [
    (name = "main", worker = .mainWorker),
    # The static files service provides access to the built files from the Astro project.
    (name = "static-files", disk = ".\dist"),
  ],

  sockets = [
    # Serve HTTP on port 8080.
    ( name = "http",
      address = "*:8080",
      http = (),
      service = "main"
    ),
  ]
);

const mainWorker :Workerd.Worker = (
  modules = [
    (name = "index.js", esModule = embed "./dist/index.js"),
  ],
  compatibilityDate = "2025-02-28",
  compatibilityFlags = [ "nodejs_compat" ],
  bindings = [
    (name = "ASSETS", service = "static-files"),
  ],
  # Learn more about compatibility dates at:
  # https://developers.cloudflare.com/workers/platform/compatibility-dates/
);