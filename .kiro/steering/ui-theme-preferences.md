# UI Theme Preferences

## Preferred Theme Style

**CRITICAL RULE:** Use dark theme with trustworthy blue color scheme and modern borders. NO glass effects or purple themes.

## Theme Specifications

### ✅ DO: Dark Theme with Blue Accents

**Background:**

- Main background: Dark slate gradients (`bg-gradient-to-br from-slate-900 to-slate-800`)
- Subtle blue radial patterns for depth (`rgba(59,130,246,0.1)`)

**Cards & Containers:**

- Background: Dark slate (`bg-slate-800`)
- Borders: Blue with transparency (`border-blue-500/30`)
- Hover effects: Blue glow shadows (`hover:shadow-blue-500/10`)

**Typography:**

- Primary text: White (`text-white`)
- Labels: Light slate (`text-slate-200`)
- Secondary text: Medium slate (`text-slate-300`)
- Muted text: Darker slate (`text-slate-400`)

**Interactive Elements:**

- Input backgrounds: Dark slate (`bg-slate-700`)
- Input borders: Slate with blue focus (`border-slate-600 focus-within:border-blue-400`)
- Links: Blue variants (`text-blue-400 hover:text-blue-300`)
- Buttons: Follow CloudScape primary styling with blue accents

**Modern Border Highlights:**

- Top accents: Blue gradients (`bg-gradient-to-r from-blue-400 via-blue-500 to-blue-400`)
- Focus states: Blue borders (`border-blue-400`)
- Container borders: Semi-transparent blue (`border-blue-500/30`)
- Bottom accents: Subtle blue lines (`via-blue-400`)

### ❌ DON'T: Glass Effects or Purple Themes

**Never use:**

- `backdrop-blur` effects
- Transparent backgrounds (`bg-white/10`, `bg-white/5`)
- Purple color schemes (`purple-500`, `purple-300`, etc.)
- Animated background blobs
- Glass morphism styling
- Overly bright or neon colors

## Color Palette

**Primary Blues:**

- `blue-400` - Links and accents
- `blue-500` - Primary borders and highlights
- `blue-600` - Darker blue elements

**Slate Grays:**

- `slate-800` - Main container backgrounds
- `slate-700` - Input backgrounds, secondary containers
- `slate-600` - Borders and dividers
- `slate-300` - Secondary text
- `slate-200` - Primary labels
- `white` - Main headings and important text

## Design Principles

1. **Trustworthy**: Professional blue color scheme conveys reliability
2. **Modern**: Clean borders and subtle shadows, no glass effects
3. **Accessible**: High contrast ratios for readability
4. **Consistent**: Same color palette across all components
5. **Focused**: Border highlights guide user attention to interactive elements

## Example Implementation

```tsx
// ✅ Correct dark theme component
export const Component = () => {
  return (
    <div className="bg-slate-800 border-2 border-blue-500/30 rounded-xl p-6">
      <h1 className="text-white font-bold">Title</h1>
      <p className="text-slate-300">Description</p>
      <input className="bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg" />
    </div>
  );
};
```

```tsx
// ❌ Wrong - glass effects and purple
export const BadComponent = () => {
  return (
    <div className="backdrop-blur-xl bg-white/10 border border-white/20">
      <h1 className="text-purple-300">Title</h1>
    </div>
  );
};
```

## Summary

- ✅ Dark slate backgrounds with blue accents
- ✅ Modern borders that highlight interactive elements
- ✅ Professional and trustworthy appearance
- ✅ High contrast for accessibility
- ❌ No glass effects, transparency, or purple themes
- ❌ No animated background elements or blur effects
