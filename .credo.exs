%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ~w{config li test}
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, max_length: 100}
      ]
    }
  ]
}
