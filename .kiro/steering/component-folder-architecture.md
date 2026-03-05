# Component Folder Architecture

## Parent-Child Component Organization Rule

**CRITICAL RULE:** When a parent component uses a child component, the child component MUST be placed inside a subfolder within the parent's folder.

## Why This Rule?

- **Clear Hierarchy**: Instantly see which components are parents and which are children
- **Easy Navigation**: Find child components by looking in parent's folder
- **Better Organization**: Component relationships are reflected in folder structure
- **Scalability**: Easy to add more children without cluttering

## Structure Pattern

```
ParentComponent/
├── ParentComponent.tsx (the parent)
└── child-component/
    └── ChildComponent.tsx (the child)
```

## Examples

### ✅ CORRECT: Child in subfolder

```
Home/
├── Home.tsx (uses SideNav and MainContent)
├── side-nav/
│   ├── SideNav.tsx (uses SideNavContent)
│   └── side-nav-content/
│       └── SideNavContent.tsx
└── main-content/
    └── MainContent.tsx
```

**Benefits:**

- Clear that `Home.tsx` is the parent
- Clear that `SideNav.tsx` uses `SideNavContent.tsx`
- Easy to find all children of a component

### ❌ WRONG: Child at same level

```
Home/
├── Home.tsx
├── SideNav.tsx
├── SideNavContent.tsx  ❌ Should be in side-nav/side-nav-content/
└── MainContent.tsx
```

**Problems:**

- Can't tell which component uses which
- Flat structure gets messy with many components
- Hard to understand component relationships

## Naming Convention

- **Folder names**: kebab-case (e.g., `side-nav-content`)
- **Component files**: PascalCase (e.g., `SideNavContent.tsx`)
- **Folder name should match component name** (converted to kebab-case)

## Real-World Example

```
auth/
├── login/
│   ├── Login.tsx (parent)
│   └── login-form/
│       └── LoginForm.tsx (child of Login)
└── register/
    ├── Register.tsx (parent)
    ├── register-form/
    │   └── RegisterForm.tsx (child of Register)
    └── email-verification/
        └── EmailVerification.tsx (child of Register)
```

## Shared Components Exception

**Shared components** (used by multiple parents) should go in a `shared/` folder at the appropriate level:

```
src/
├── shared/
│   ├── Logo.tsx (used by many components)
│   └── Button.tsx (used by many components)
└── Home/
    └── Home.tsx
```

## Summary

- ✅ Child components go in subfolders of their parent
- ✅ Folder structure mirrors component hierarchy
- ✅ Makes codebase self-documenting
- ✅ Easy to navigate and understand relationships
- ❌ Never put child components at the same level as parent
