import React from 'react';

export function Card({ 
  children, 
  className = '', 
  title 
}: any) {
  return (
    <div className={`rounded-xl border border-border bg-card text-card-foreground shadow-sm ${className}`}>
      {title && (
        <div className="flex flex-col space-y-1.5 p-6 pb-2">
          <h3 className="font-semibold leading-none tracking-tight">{title}</h3>
        </div>
      )}
      <div className="p-6 pt-0 mt-6">
        {children}
      </div>
    </div>
  );
}
