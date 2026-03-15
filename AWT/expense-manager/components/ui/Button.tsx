import React from "react";
export function Button({
  children,
  className = "",
  variant = "primary",
  size = "md",
  fullWidth = false,
  ...props
}: any) {
  let classes =
    "inline-flex items-center justify-center rounded-xl font-medium uppercase tracking-wider active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:pointer-events-none disabled:opacity-50 ";
  const hasBgOverride = className.includes("bg-");
  const hasTextOverride = className.includes("text-");
  if (variant === "primary") {
    classes += `${hasBgOverride ? "" : "bg-primary "} ${hasTextOverride ? "" : "text-primary-foreground "} hover:opacity-90 shadow-lg shadow-primary/10 glow-primary `;
  }
  if (variant === "secondary")
    classes +=
      "bg-secondary text-foreground hover:bg-secondary/80 border border-white/10 ";
  if (variant === "ghost")
    classes += "bg-transparent text-foreground hover:bg-white/5 shadow-none ";
  if (variant === "danger")
    classes +=
      "bg-rose-500/10 text-rose-400 hover:bg-rose-500/20 border border-rose-500/20 shadow-none ";
  if (variant === "outline")
    classes +=
      "border border-primary/30 bg-transparent text-primary hover:bg-primary/5 shadow-none ";
  if (size === "sm") classes += "h-8 px-3 text-[10px] ";
  if (size === "md") classes += "h-10 px-5 text-[11.5px] ";
  if (size === "lg") classes += "h-12 px-8 text-[13px] ";
  if (size === "icon") classes += "h-9 w-9 p-0 ";
  if (fullWidth) classes += "w-full ";
  if (className) classes += className;
  return (
    <button className={classes.trim()} {...props} suppressHydrationWarning>
      {children}
    </button>
  );
}