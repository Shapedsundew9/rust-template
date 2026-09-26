# Clean Code

Execute these steps to maintain clean and readable code:

- For Rust code changes, run the same analysis stack used by VS Code before finishing:
  inspect rust-analyzer diagnostics in the editor and run `cargo clippy --all-targets --all-features -- -D warnings` and `cargo fmt --check`.
- Ensure all issues reported by the analysis stack are addressed.
- Do not suppress any warnings. If you think the code or documentation would be better with a suppression ask the user first.
