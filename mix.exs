defmodule Mix.Tasks.Compile.Libsecp256k1 do
  def run(_) do
    run_command("git", ["submodule", "update", "--recursive"])
    # run_script("autogen.sh", cd: "c_src/secp256k1")
    # run_script("configure --enable-module-recovery", cd: "c_src/secp256k1")
    run_command("make", [], cd: "c_src/secp256k1")
    run_command("make", [])
  end

  defp run_script(command, options \\ []) do
    run_command("sh", String.split(command, " "), options)
  end

  defp run_command(command, args, options \\ []) do
    defaults = [into: IO.stream(:stdio, :line)]
    options = Keyword.merge(defaults, options)
    case System.cmd(command, args, options) do
      {_stream, 0} -> :ok
      {message, _} -> IO.inspect message
    end

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
      compilers: [:libsecp256k1, :elixir, :app],
      deps: deps()
    ]
  end

  defp deps() do
    [
      {:ex_doc, "~> 0.17", only: :dev, runtime: false}
    ]
  end
end
