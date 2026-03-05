# Simplicity First

## Core Principle

**CRITICAL RULE:** Do EXACTLY what is asked. No more, no less. Don't add complexity that wasn't requested.

## Anti-Patterns to Avoid

### ❌ DON'T: Over-engineer simple requests

```typescript
// User asks: "Put the IP in a constant"
// WRONG - unnecessary object wrapper
export const API_CONFIG = {
  BASE_URL: "http://13.53.199.82:8001",
} as const;

// Then remapping it elsewhere
const API_BASE_URL = API_CONFIG.BASE_URL; // WHY?!
```

### ✅ DO: Implement exactly what was asked

```typescript
// User asks: "Put the IP in a constant"
// CORRECT - simple exported constant
export const API_BASE_URL = "http://13.53.199.82:8001";
```

## When NOT to Add Extra Features

- **"Future-proofing"** - Don't add structure for hypothetical future needs
- **"Best practices"** - If it adds complexity the user didn't ask for, skip it
- **"Scalability"** - Only add when explicitly needed, not "just in case"
- **"Flexibility"** - Don't create abstractions that weren't requested

## The Right Approach

1. Read the request carefully
2. Implement EXACTLY what was asked
3. Don't add layers, wrappers, or abstractions unless requested
4. If you think something extra might be useful, ASK first

## Examples

### Request: "Create a function to add two numbers"

```typescript
// ❌ WRONG - over-engineered
interface MathOperation {
  operation: "add" | "subtract" | "multiply";
  operands: number[];
}

class Calculator {
  execute(op: MathOperation): number {
    if (op.operation === "add") {
      return op.operands.reduce((a, b) => a + b, 0);
    }
    // ...
  }
}

// ✅ CORRECT - exactly what was asked
export const add = (a: number, b: number): number => {
  return a + b;
};
```

### Request: "Store the user's name in state"

```typescript
// ❌ WRONG - unnecessary complexity
interface UserState {
  name: string;
  metadata: {
    lastUpdated: Date;
    source: string;
  };
}

const [user, setUser] = useState<UserState>({
  name: "",
  metadata: { lastUpdated: new Date(), source: "initial" },
});

// ✅ CORRECT - simple and direct
const [name, setName] = useState("");
```

## Red Flags You're Over-Engineering

- Creating objects when a simple value works
- Adding abstraction layers that aren't used
- Remapping/reassigning variables for no reason
- Building for "what if" scenarios that weren't mentioned
- Adding configuration that has only one value

## Summary

- ✅ Do exactly what is requested
- ✅ Keep it simple and direct
- ✅ Ask before adding extra features
- ❌ Don't "future-proof" without being asked
- ❌ Don't add abstraction layers unnecessarily
- ❌ Don't remap or wrap simple values

**Remember:** The simplest solution that solves the problem is usually the best solution.
