defmodule Mix.Tasks.Compile.Secp256k1 do
  def run(_) do
    if match? {:win32, _}, :os.type do
      IO.warn("Windows is not supported.")
      exit(1)
    else
      {result, _error_code} = System.cmd("make", ["priv/libsecp256k1_nif.so"], stderr_to_stdout: true)
      IO.binwrite result
    end
    :ok
  end
end

defmodule Libsecp256k1.Mixfile do
  use Mix.Project

  def project do
    [
      app: :libsecp256k1,
      version: "0.1.10",
      language: :erlang,
      description: "Erlang NIF bindings for the the libsecp256k1 library",
      package: [
        maintainers: ["Matthew Branton", "Geoffrey Hayes", "Mason Fischer"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/exthereum/libsecp256k1"}
      ],
      compilers: [:secp256k1, :elixir, :app],
      deps: deps()
    ]
  end

  defp deps() do
    [
      {
        :libsecp256k1,
        github: "bitcoin-core/secp256k1",
        ref: "d33352151699bd7598b868369dace092f7855740",
        app: false,
        compile: "./autogen.sh && ./configure && make",
      },
      {:ex_doc, "~> 0.17", only: :dev, runtime: false}
    ]
  end
end
