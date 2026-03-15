"use client";
import React from "react";
import { Button } from "./Button";
import { Card } from "./Card";
import { AlertTriangle, X } from "lucide-react";
interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  confirmText?: string;
  cancelText?: string;
  variant?: "danger" | "primary";
}
export function ConfirmModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText = "Delete",
  cancelText = "Cancel",
  variant = "danger",
}: ConfirmModalProps) {
  if (!isOpen) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-sm">
      <div className="w-full max-w-md">
        <Card className="relative overflow-hidden border-border shadow-2xl">
          <button
            onClick={onClose}
            className="absolute top-4 right-4 p-1 text-muted-foreground hover:text-foreground transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
          <div className="p-6">
            <div className="flex items-center gap-4 mb-4">
              <div
                className={`h-12 w-12 rounded-full flex items-center justify-center ${
                  variant === "danger"
                    ? "bg-rose-500/10 text-rose-500"
                    : "bg-primary/10 text-primary"
                }`}
              >
                <AlertTriangle className="h-6 w-6" />
              </div>
              <h3 className="text-xl font-semibold text-foreground tracking-tight">
                {title}
              </h3>
            </div>
            <p className="text-muted-foreground text-sm leading-relaxed mb-8">
              {message}
            </p>
            <div className="flex gap-3">
              <Button
                variant="ghost"
                onClick={onClose}
                className="flex-1 rounded-xl border border-border"
              >
                {cancelText}
              </Button>
              <Button
                variant={variant === "danger" ? "danger" : "primary"}
                onClick={() => {
                  onConfirm();
                  onClose();
                }}
                className={`flex-1 rounded-xl font-medium ${variant === "danger" ? "bg-rose-600 hover:bg-rose-700 text-white" : ""}`}
              >
                {confirmText}
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}