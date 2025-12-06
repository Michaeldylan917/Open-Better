# ArkTS Lint Rules - Cursor Rules

## 概述
ArkTS（TypeScript的子集）的Lint规则，用于确保代码符合HarmonyOS开发规范。

## 规则统计
- 总规则数量: 67
- 严重程度: error
- 适用范围: ArkTS/TypeScript代码

## 规则列表

### JSON格式
```json
[
  {
    "name": "arkts-no-aliases-by-index",
    "severity": "error",
    "description": "ArkTS does not support indexed access types.",
    "suggestion": "Use direct type names instead of indexed access type notation."
  },
  {
    "name": "arkts-no-ambient-decls",
    "severity": "error",
    "description": "ArkTS does not support ambient module declarations.",
    "suggestion": "Import directly from modules without ambient declarations."
  },
  {
    "name": "arkts-no-any-unknown",
    "severity": "error",
    "description": "ArkTS does not support any and unknown types to enforce static typing.",
    "suggestion": "Specify explicit types. Use Object for general objects or specific types for better type safety."
  },
  {
    "name": "arkts-no-as-const",
    "severity": "error",
    "description": "ArkTS does not support as const assertions.",
    "suggestion": "Use explicit type annotations instead of as const."
  },
  {
    "name": "arkts-no-call-signatures",
    "severity": "error",
    "description": "ArkTS does not support call signatures in object types.",
    "suggestion": "Use a class with an invoke() method instead."
  },
  {
    "name": "arkts-no-class-literals",
    "severity": "error",
    "description": "ArkTS does not support anonymous class literals.",
    "suggestion": "Define named classes instead of using class literals."
  },
  {
    "name": "arkts-no-classes-as-obj",
    "severity": "error",
    "description": "ArkTS does not support using classes as objects.",
    "suggestion": "Use explicit class instantiation or type references instead of class objects."
  },
  {
    "name": "arkts-no-comma-outside-loops",
    "severity": "error",
    "description": "ArkTS supports comma operator only in for loops.",
    "suggestion": "Use separate statements instead of comma operator for sequential execution."
  },
  {
    "name": "arkts-no-conditional-types",
    "severity": "error",
    "description": "ArkTS does not support conditional type aliases or the infer keyword.",
    "suggestion": "Provide explicit type constraints or rewrite logic using Object types."
  },
  {
    "name": "arkts-no-ctor-prop-decls",
    "severity": "error",
    "description": "ArkTS does not support declaring class fields directly in constructor parameters.",
    "suggestion": "Declare all class fields explicitly inside the class body."
  },
  {
    "name": "arkts-no-ctor-signatures-funcs",
    "severity": "error",
    "description": "ArkTS does not support constructor function types.",
    "suggestion": "Use lambda types instead of constructor function types."
  },
  {
    "name": "arkts-no-ctor-signatures-iface",
    "severity": "error",
    "description": "ArkTS does not support constructor signatures in interfaces.",
    "suggestion": "Use factory methods in interfaces instead of constructors."
  },
  {
    "name": "arkts-no-ctor-signatures-type",
    "severity": "error",
    "description": "ArkTS does not support constructor signatures in object types.",
    "suggestion": "Use a class with a proper constructor instead."
  },
  {
    "name": "arkts-no-decl-merging",
    "severity": "error",
    "description": "ArkTS does not support declaration merging for classes, interfaces, or enums.",
    "suggestion": "Keep all declarations compact and define them in a single place."
  },
  {
    "name": "arkts-no-definite-assignment",
    "severity": "error",
    "description": "ArkTS does not support definite assignment assertions (!).",
    "suggestion": "Initialize variables at declaration or in constructors."
  },
  {
    "name": "arkts-no-delete",
    "severity": "error",
    "description": "ArkTS does not support the delete operator as object layout is fixed at compile time.",
    "suggestion": "Use nullable types and assign null to mark value absence."
  },
  {
    "name": "arkts-no-destruct-assignment",
    "severity": "error",
    "description": "ArkTS does not support destructuring assignment.",
    "suggestion": "Use temporary variables and manual assignment instead."
  },
  {
    "name": "arkts-no-destruct-decls",
    "severity": "error",
    "description": "ArkTS does not support destructuring variable declarations.",
    "suggestion": "Create intermediate objects and access properties individually."
  },
  {
    "name": "arkts-no-destruct-params",
    "severity": "error",
    "description": "ArkTS does not support destructuring in function parameters.",
    "suggestion": "Pass parameters directly and assign local names manually inside the function."
  },
  {
    "name": "arkts-no-enum-merging",
    "severity": "error",
    "description": "ArkTS does not support enum declaration merging.",
    "suggestion": "Define all enum members in a single enum declaration."
  },
  {
    "name": "arkts-no-enum-mixed-types",
    "severity": "error",
    "description": "ArkTS requires enum members to be initialized with compile-time constants of the same type.",
    "suggestion": "Use consistent enum member types and compile-time constant values."
  },
  {
    "name": "arkts-no-export-assignment",
    "severity": "error",
    "description": "ArkTS does not support export = ... syntax.",
    "suggestion": "Use named or default exports instead."
  },
  {
    "name": "arkts-no-extend-same-prop",
    "severity": "error",
    "description": "ArkTS does not allow interfaces extending multiple interfaces with the same method name.",
    "suggestion": "Use distinct method names or refactor to use separate interfaces."
  },
  {
    "name": "arkts-no-for-in",
    "severity": "error",
    "description": "ArkTS does not support for..in loops for object property iteration.",
    "suggestion": "Use regular for loops with arrays or iterate over known properties."
  },
  {
    "name": "arkts-no-func-apply-call",
    "severity": "error",
    "description": "ArkTS does not support Function.apply() or Function.call().",
    "suggestion": "Use direct function calls with proper parameter passing."
  },
  {
    "name": "arkts-no-func-bind",
    "severity": "error",
    "description": "ArkTS does not support Function.bind().",
    "suggestion": "Use arrow functions or explicitly bind this in class methods."
  },
  {
    "name": "arkts-no-func-expressions",
    "severity": "error",
    "description": "ArkTS does not support function expressions.",
    "suggestion": "Use arrow functions (=>) instead of function expressions."
  },
  {
    "name": "arkts-no-func-props",
    "severity": "error",
    "description": "ArkTS does not support declaring properties on functions.",
    "suggestion": "Use classes instead of functions with properties."
  },
  {
    "name": "arkts-no-generators",
    "severity": "error",
    "description": "ArkTS does not support generator functions.",
    "suggestion": "Use async/await mechanism for asynchronous iteration."
  },
  {
    "name": "arkts-no-globalthis",
    "severity": "error",
    "description": "ArkTS does not support globalThis or global scope.",
    "suggestion": "Use explicit module imports and exports instead of global variables."
  },
  {
    "name": "arkts-no-implicit-return-types",
    "severity": "error",
    "description": "ArkTS has limited function return type inference.",
    "suggestion": "Always specify explicit return types for functions."
  },
  {
    "name": "arkts-no-import-assertions",
    "severity": "error",
    "description": "ArkTS does not support import assertions.",
    "suggestion": "Use regular import syntax without assertions."
  },
  {
    "name": "arkts-no-in",
    "severity": "error",
    "description": "ArkTS does not support the in operator for property existence checks.",
    "suggestion": "Use instanceof to check class membership or access properties directly."
  },
  {
    "name": "arkts-no-indexed-signatures",
    "severity": "error",
    "description": "ArkTS does not allow indexed signatures in interfaces.",
    "suggestion": "Use arrays or explicit class properties instead."
  },
  {
    "name": "arkts-no-inferred-generic-params",
    "severity": "error",
    "description": "ArkTS does not infer generic type parameters based solely on return types.",
    "suggestion": "Explicitly specify generic type parameters when they cannot be inferred from arguments."
  },
  {
    "name": "arkts-no-intersection-types",
    "severity": "error",
    "description": "ArkTS does not support intersection types.",
    "suggestion": "Use interface inheritance to combine multiple types."
  },
  {
    "name": "arkts-no-is",
    "severity": "error",
    "description": "ArkTS does not support the is type guard operator.",
    "suggestion": "Use instanceof for type checking and as for type casting."
  },
  {
    "name": "arkts-no-jsx",
    "severity": "error",
    "description": "ArkTS does not support JSX expressions.",
    "suggestion": "No direct alternative; use ArkTS UI syntax instead."
  },
  {
    "name": "arkts-no-mapped-types",
    "severity": "error",
    "description": "ArkTS does not support mapped types.",
    "suggestion": "Use regular classes with explicitly declared properties instead."
  },
  {
    "name": "arkts-no-method-reassignment",
    "severity": "error",
    "description": "ArkTS does not support reassigning object methods.",
    "suggestion": "Use inheritance to override methods or create wrapper functions."
  },
  {
    "name": "arkts-no-misplaced-imports",
    "severity": "error",
    "description": "ArkTS requires all import statements before other statements.",
    "suggestion": "Move all import statements to the beginning of the file."
  },
  {
    "name": "arkts-no-module-wildcards",
    "severity": "error",
    "description": "ArkTS does not support wildcards in module names.",
    "suggestion": "Use explicit module names and regular import/export syntax."
  },
  {
    "name": "arkts-no-multiple-static-blocks",
    "severity": "error",
    "description": "ArkTS does not allow multiple static blocks for class initialization.",
    "suggestion": "Combine all static initialization statements into a single static block."
  },
  {
    "name": "arkts-no-nested-funcs",
    "severity": "error",
    "description": "ArkTS does not support nested function declarations.",
    "suggestion": "Use lambda expressions (arrow functions) instead."
  },
  {
    "name": "arkts-no-new-target",
    "severity": "error",
    "description": "ArkTS does not support new.target meta-property.",
    "suggestion": "Not applicable in static typing context; use class-based patterns."
  },
  {
    "name": "arkts-no-noninferrable-arr-literals",
    "severity": "error",
    "description": "ArkTS requires array literal elements to have inferrable types.",
    "suggestion": "Use explicit type assertions or annotate array types when elements have non-inferrable types."
  },
  {
    "name": "arkts-no-ns-as-obj",
    "severity": "error",
    "description": "ArkTS does not support using namespaces as objects.",
    "suggestion": "Use classes or modules instead of namespaces as objects."
  },
  {
    "name": "arkts-no-ns-statements",
    "severity": "error",
    "description": "ArkTS does not support executable statements directly in namespaces.",
    "suggestion": "Wrap statements in namespace functions and call them explicitly."
  },
  {
    "name": "arkts-no-obj-literals-as-types",
    "severity": "error",
    "description": "ArkTS does not support using object literals as inline type declarations.",
    "suggestion": "Declare named classes or interfaces instead of inline object type literals."
  },
  {
    "name": "arkts-no-polymorphic-unops",
    "severity": "error",
    "description": "Unary operators +, -, ~ work only on numeric types in ArkTS.",
    "suggestion": "Explicitly convert non-numeric types to numbers before applying unary operators."
  },
  {
    "name": "arkts-no-private-identifiers",
    "severity": "error",
    "description": "ArkTS does not support private identifiers starting with #.",
    "suggestion": "Use the private keyword instead."
  },
  {
    "name": "arkts-no-props-by-index",
    "severity": "error",
    "description": "ArkTS does not support dynamic property access via index notation.",
    "suggestion": "Declare all fields in class definitions and use dot notation (obj.field) for access."
  },
  {
    "name": "arkts-no-prototype-assignment",
    "severity": "error",
    "description": "ArkTS does not support prototype assignment.",
    "suggestion": "Use class inheritance and methods instead of prototype manipulation."
  },
  {
    "name": "arkts-no-require",
    "severity": "error",
    "description": "ArkTS does not support require() or import assignment syntax.",
    "suggestion": "Use ES6 import syntax instead."
  },
  {
    "name": "arkts-no-spread",
    "severity": "error",
    "description": "ArkTS supports spread operator only for arrays in rest parameters or array literals.",
    "suggestion": "Manually unpack arrays and objects; use constructors for object composition."
  },
  {
    "name": "arkts-no-standalone-this",
    "severity": "error",
    "description": "ArkTS does not support this in stand-alone functions or static methods.",
    "suggestion": "Use this only in instance methods; use explicit parameters otherwise."
  },
  {
    "name": "arkts-no-structural-typing",
    "severity": "error",
    "description": "ArkTS does not support structural typing where types are compared by shape.",
    "suggestion": "Use explicit inheritance or interface implementation to establish type relationships."
  },
  {
    "name": "arkts-no-symbol",
    "severity": "error",
    "description": "ArkTS does not support Symbol() API as it doesn't make sense in statically typed environment where object layout is fixed at compile time. Only Symbol.iterator is supported.",
    "suggestion": "Use explicit property names instead of Symbol(). For iteration protocols, use Symbol.iterator where supported."
  },
  {
    "name": "arkts-no-ts-deps",
    "severity": "error",
    "description": "TypeScript code must not depend on ArkTS code.",
    "suggestion": "Ensure TypeScript files do not import from ArkTS files; reverse direction is allowed."
  },
  {
    "name": "arkts-no-type-query",
    "severity": "error",
    "description": "ArkTS supports typeof only in expressions, not in type annotations.",
    "suggestion": "Use explicit type names instead of typeof in type positions."
  },
  {
    "name": "arkts-no-types-in-catch",
    "severity": "error",
    "description": "ArkTS does not support type annotations in catch clauses.",
    "suggestion": "Omit type annotations in catch clauses; use type guards if needed."
  },
  {
    "name": "arkts-no-typing-with-this",
    "severity": "error",
    "description": "ArkTS does not support type notation using the this keyword.",
    "suggestion": "Use explicit type names instead of this in type annotations."
  },
  {
    "name": "arkts-no-umd",
    "severity": "error",
    "description": "ArkTS does not support Universal Module Definition (UMD).",
    "suggestion": "Use ES6 modules with standard import/export syntax."
  },
  {
    "name": "arkts-no-untyped-obj-literals",
    "severity": "error",
    "description": "ArkTS requires object literals to correspond to explicitly declared classes or interfaces.",
    "suggestion": "Always declare a class or interface type for object literals before use."
  },
  {
    "name": "arkts-no-utility-types",
    "severity": "error",
    "description": "ArkTS does not support most TypeScript utility types.",
    "suggestion": "Define explicit types instead of using utility types (except Partial, Required, Readonly, Record)."
  },
  {
    "name": "arkts-no-var",
    "severity": "error",
    "description": "ArkTS does not support var declarations due to scoping issues.",
    "suggestion": "Use let instead of var for variable declarations."
  },
  {
    "name": "arkts-no-with",
    "severity": "error",
    "description": "ArkTS does not support the with statement.",
    "suggestion": "Use explicit object references instead of with."
  }
]
```

## 使用说明

### 在Cursor中使用
1. 将此文件保存为 `.cursorrules` 文件
2. 配置TypeScript/ArkTS项目的ESLint规则
3. 确保IDE能够识别这些规则

### 规则应用
这些规则主要用于：
- TypeScript到ArkTS的迁移
- HarmonyOS应用开发
- 确保代码符合ArkTS规范

## 参考资源
- [HarmonyOS ArkTS开发指南](https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V14/typescript-to-arkts-migration-guide-V14)
- 生成时间: 2025-12-03 01:31:30

---
*此文件由ArkTS规则提取器自动生成*
