import js from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
  { ignores: ["node_modules/**"] },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      "no-restricted-syntax": ["error", "IfStatement", "ForStatement", "ForInStatement", "ForOfStatement", "DoWhileStatement", "SequenceExpression"],
      "no-var": "error",
      "prefer-const": "error",
      "no-shadow": "error",
      "eqeqeq": ["error", "smart"],
      "no-console": "off"
    }
  }
);
