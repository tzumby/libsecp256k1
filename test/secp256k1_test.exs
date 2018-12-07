defmodule Secp256k1Test do
  use ExUnit.Case

  test "Create keys" do
    random_bytes = :crypto.strong_rand_bytes(32)
    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(random_bytes, :compressed)
    {:ok, uncompressed_public_key} = :libsecp256k1.ec_pubkey_create(random_bytes, :uncompressed)
    assert {:ok, uncompressed_public_key} == :libsecp256k1.ec_pubkey_decompress(public_key)

    assert :libsecp256k1.ec_pubkey_verify(public_key) == :ok
    assert :libsecp256k1.ec_pubkey_verify(uncompressed_public_key) == :ok
  end

  test "Invalid keys" do
    random_bytes = :crypto.strong_rand_bytes(16)

    invalid_random_bytes = :crypto.strong_rand_bytes(16)

    assert {:error, _message} = :libsecp256k1.ec_pubkey_create(invalid_random_bytes, :compressed)
    assert {:error, _message} = :libsecp256k1.ec_pubkey_create(random_bytes, :invalidflag)
  end

  test "Import export" do
    random_bytes = :crypto.strong_rand_bytes(32)

    {:ok, private_key} = :libsecp256k1.ec_privkey_export(random_bytes, :compressed)

    assert :libsecp256k1.ec_privkey_import(private_key) == {:ok, random_bytes}
  end

  test "Tweaks" do
    private_key = :crypto.strong_rand_bytes(32)
    tweak = :crypto.strong_rand_bytes(32)
    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(private_key, :compressed)
    {:ok, private_key_tweak_add} = :libsecp256k1.ec_privkey_tweak_add(private_key, tweak)
    {:ok, private_key_tweak_mul} = :libsecp256k1.ec_privkey_tweak_mul(private_key, tweak)
    {:ok, public_key_tweak_add} = :libsecp256k1.ec_pubkey_tweak_add(public_key, tweak)
    {:ok, public_key_tweak_mul} = :libsecp256k1.ec_pubkey_tweak_mul(public_key, tweak)
    assert :libsecp256k1.ec_pubkey_create(private_key_tweak_add, :compressed) == {:ok, public_key_tweak_add}
    assert :libsecp256k1.ec_pubkey_create(private_key_tweak_mul, :compressed) == {:ok, public_key_tweak_mul}
  end

  test "Signing" do
    message = "This is a secret message..."
    random_bytes = :crypto.strong_rand_bytes(32)
    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(random_bytes, :compressed)
    {:ok, signature} = :libsecp256k1.ecdsa_sign(message, random_bytes, :default, <<>>)
    assert :libsecp256k1.ecdsa_verify(message, signature, public_key) == :ok
  end

  test "Blank message" do
    message = <<>>
    random_bytes = :crypto.strong_rand_bytes(32)
    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(random_bytes, :compressed)
    {:ok, signature} = :libsecp256k1.ecdsa_sign(message, random_bytes, :default, <<>>)
    assert :libsecp256k1.ecdsa_verify(message, signature, public_key) == :ok
  end

  test "Compact signing" do
    message = "This is a very secret compact message..."
    random_bytes = :crypto.strong_rand_bytes(32)
    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(random_bytes, :uncompressed)
    {:ok, signature, recovery_id} = :libsecp256k1.ecdsa_sign_compact(message, random_bytes, :default, <<>>)
    {:ok, recovered_key} = :libsecp256k1.ecdsa_recover_compact(message, signature, :uncompressed, recovery_id)
    assert public_key == recovered_key
    assert :libsecp256k1.ecdsa_verify_compact(message, signature, public_key) == :ok

  end

  test "Sha256" do
    random_bytes = :crypto.strong_rand_bytes(64)
    double_hashed = :crypto.hash(:sha256, :crypto.hash(:sha256, random_bytes))
    assert :libsecp256k1.sha256(:libsecp256k1.sha256(random_bytes)) == double_hashed
    assert :libsecp256k1.dsha256(random_bytes) == double_hashed
	end
end
