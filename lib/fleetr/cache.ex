defmodule Fleetr.Cache do
  use Nebulex.Cache,
    otp_app: :fleetr,
    adapter: Nebulex.Adapters.Local
end
