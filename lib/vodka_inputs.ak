use aiken/list
use aiken/transaction.{InlineDatum, Input}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{AssetName, PolicyId, flatten, quantity_of}

/// Extracts the inline datum from an input.
/// ```aiken
/// expect inline_datum: MyDatumType = output_inline_datum(input);
/// ```
pub fn output_inline_datum(input: Input) {
  expect InlineDatum(raw_datum) = input.output.datum
  raw_datum
}

/// Extract the inline datum by locating the first input in a list of inputs by Address and PolicyId.
/// ```aiken
/// expect inline_datum: MyDatumType = only_input_datum_with(inputs, policy, name);
/// ```
pub fn only_input_datum_with(
  inputs: List<Input>,
  policy: PolicyId,
  name: AssetName,
) {
  expect Some(input) =
    list.find(
      inputs,
      fn(input) { quantity_of(input.output.value, policy, name) == 1 },
    )
  output_inline_datum(input)
}

/// Filters inputs by Address.
/// ```aiken
/// let filtered_inputs = inputs_at(inputs, address);
/// ```
pub fn inputs_at(inputs: List<Input>, address: Address) -> List<Input> {
  list.filter(inputs, fn(input) { input.output.address == address })
}

/// Filters inputs by PolicyId and AssetName.
/// ```aiken
/// let filtered_inputs = inputs_with(inputs, policy, name);
/// ```
pub fn inputs_with(
  inputs: List<Input>,
  policy: PolicyId,
  name: AssetName,
) -> List<Input> {
  list.filter(
    inputs,
    fn(input) { quantity_of(input.output.value, policy, name) == 1 },
  )
}

/// Filters inputs by token policy.
/// ```aiken
/// let filtered_inputs = inputs_with_policy(inputs, policy);
/// ```
pub fn inputs_with_policy(inputs: List<Input>, policy: PolicyId) -> List<Input> {
  list.filter(
    inputs,
    fn(input) {
      list.any(flatten(input.output.value), fn(token) { token.1st == policy })
    },
  )
}

/// Filters inputs by Address, PolicyId, and AssetName.
/// ```aiken
/// let filtered_inputs = inputs_at_with(inputs, address, policy, name);
/// ```
pub fn inputs_at_with(
  inputs: List<Input>,
  address: Address,
  policy: PolicyId,
  name: AssetName,
) -> List<Input> {
  list.filter(
    inputs,
    fn(input) {
      input.output.address == address && quantity_of(
        input.output.value,
        policy,
        name,
      ) == 1
    },
  )
}

/// Filters inputs by Address and PolicyId.
/// ```aiken
/// let filtered_inputs = inputs_at_with_policy(inputs, address, policy);
/// ```
pub fn inputs_at_with_policy(
  inputs: List<Input>,
  address: Address,
  policy: PolicyId,
) -> List<Input> {
  list.filter(
    inputs,
    fn(input) {
      input.output.address == address && list.any(
        flatten(input.output.value),
        fn(token) { token.1st == policy },
      )
    },
  )
}

/// Calculate the total quantity of a token in a list of inputs.
/// ```aiken
/// let total_quantity = inputs_token_quantity(inputs, token);
/// ```
pub fn inputs_token_quantity(
  inputs: List<Input>,
  token: (PolicyId, AssetName),
) -> Int {
  list.map(
    inputs,
    fn(input) { quantity_of(input.output.value, token.1st, token.2nd) },
  )
    |> list.foldr(0, fn(n, total) { n + total })
}
