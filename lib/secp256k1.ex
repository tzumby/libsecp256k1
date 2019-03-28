defmodule :libsecp256k1 do
  @compile {:autoload, false}
  @on_load {:init, 0}

  app = Mix.Project.config()[:app]

  def init do
    path = :filename.join(:code.priv_dir(unquote(app)), 'libsecp256k1_nif')
    :ok = :erlang.load_nif(path, 0)
  end

  def dsha256(_), do: exit(:nif_library_not_loaded)

  def sha256(_), do: exit(:nif_library_not_loaded)

  def hmac_sha256(_, _), do: exit(:nif_library_not_loaded)

  def rand32(), do: exit(:nif_library_not_loaded)

  def rand256(), do: exit(:nif_library_not_loaded)

  def ec_seckey_verify(_), do: exit(:nif_library_not_loaded)

  def ec_pubkey_create(_, _), do: exit(:nif_library_not_loaded)

  def ec_pubkey_decompress(_), do: exit(:nif_library_not_loaded)

  def ec_pubkey_verify(_), do: exit(:nif_library_not_loaded)

  def ec_privkey_export(_, _), do: exit(:nif_library_not_loaded)

  def ec_privkey_import(_), do: exit(:nif_library_not_loaded)

  def ec_privkey_tweak_add(_, _), do: exit(:nif_library_not_loaded)

  def ec_pubkey_tweak_add(_, _), do: exit(:nif_library_not_loaded)

  def ec_privkey_tweak_mul(_, _), do: exit(:nif_library_not_loaded)

  def ec_pubkey_tweak_mul(_, _), do: exit(:nif_library_not_loaded)

  def ecdsa_sign(_, _, _, _), do: exit(:nif_library_not_loaded)

  def ecdsa_verify(_, _, _), do: exit(:nif_library_not_loaded)

  def ecdsa_sign_compact(_, _, _, _), do: exit(:nif_library_not_loaded)

  def ecdsa_verify_compact(_, _, _), do: exit(:nif_library_not_loaded)

  def ecdsa_recover_compact(_, _, _, _), do: exit(:nif_library_not_loaded)
end
