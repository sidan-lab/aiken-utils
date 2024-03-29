use aiken/bytearray
use aiken/transaction/credential.{
  Address, ScriptCredential, VerificationKeyCredential,
}

pub fn compare_script_address(x: Address, y: Address) -> Ordering {
  expect ScriptCredential(x_hash) = x.payment_credential
  expect ScriptCredential(y_hash) = y.payment_credential
  bytearray.compare(x_hash, y_hash)
}

pub fn compare_address(x: Address, y: Address) -> Ordering {
  let x_hash = x.payment_credential
  let y_hash = y.payment_credential
  when (x_hash, y_hash) is {
    (ScriptCredential(x_script_hash), ScriptCredential(y_script_hash)) ->
      bytearray.compare(x_script_hash, y_script_hash)
    (
      VerificationKeyCredential(x_key_hash),
      VerificationKeyCredential(y_key_hash),
    ) -> bytearray.compare(x_key_hash, y_key_hash)
    _ -> Equal
  }
}
