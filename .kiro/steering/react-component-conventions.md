# React Component Conventions

## Component Declaration Rules

When creating React components, follow these strict conventions:

### ✅ DO: Use Arrow Function Syntax with Named Exports

```tsx
export const ComponentName = () => {
  return <div>Content</div>;
};
```

### ❌ DON'T: Use Function Keyword

```tsx
// NEVER do this
function ComponentName() {
  return <div>Content</div>;
}
```

### ❌ DON'T: Use Default Exports

```tsx
// NEVER do this
export default ComponentName;
```

## Why These Rules?

- **Consistency**: All components follow the same pattern
- **Named exports**: Makes imports explicit and refactoring easier
- **Arrow functions**: Modern JavaScript convention
- **Better tree-shaking**: Named exports work better with bundlers

## Examples

```tsx
// ✅ Correct
export const Button = ({ label }: { label: string }) => {
  return <button>{label}</button>;
};

// ✅ Correct with FC type
export const Card: FC<CardProps> = ({ children }) => {
  return <div className="card">{children}</div>;
};

// ❌ Wrong - function keyword
function Header() {
  return <header>Header</header>;
}

// ❌ Wrong - default export
export default Footer;
```
