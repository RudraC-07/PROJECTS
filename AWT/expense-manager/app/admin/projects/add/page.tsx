"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import Link from "next/link";
import { ArrowLeft, Briefcase } from "lucide-react";
export default function AddProjectPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    projectName: "",
    projectDetail: "",
    description: "",
    startDate: "",
    endDate: "",
  });
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({
    type: "",
    text: "",
  });
  const handleChange = (e: any) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };
  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setMessage({
      type: "",
      text: "",
    });
    try {
      const res = await fetch("/api/projects", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || "Failed to create project");
      setMessage({
        type: "success",
        text: "Project created successfully!",
      });
      setTimeout(() => {
        router.push("/admin/projects");
        router.refresh();
      }, 1500);
    } catch (err: any) {
      setMessage({
        type: "error",
        text: err.message,
      });
      setLoading(false);
    }
  };
  return (
    <div className="max-w-3xl mx-auto space-y-6">
      {" "}
      <div className="flex items-center gap-4">
        {" "}
        <Link href="/admin/projects">
          {" "}
          <Button variant="ghost" size="icon" className="rounded-full">
            {" "}
            <ArrowLeft className="h-5 w-5" />{" "}
          </Button>{" "}
        </Link>{" "}
        <div>
          {" "}
          <h1 className="text-2xl font-semibold">Add Project</h1>{" "}
          <p className="text-muted-foreground text-sm">
            Start a new project to track its expenses.
          </p>{" "}
        </div>{" "}
      </div>{" "}
      <Card className="shadow-xl border-border/50 p-8">
        {" "}
        <form onSubmit={handleSubmit} className="space-y-6">
          {" "}
          <div className="grid grid-cols-1 gap-6">
            {" "}
            <Input
              label="Project Name"
              name="projectName"
              required
              value={formData.projectName}
              onChange={handleChange}
              placeholder="e.g. Q1 Marketing Campaign"
              className="bg-secondary/30"
            />{" "}
            <div className="space-y-2">
              {" "}
              <label className="text-sm font-medium">
                Project Detail / Scope
              </label>{" "}
              <textarea
                name="projectDetail"
                value={formData.projectDetail}
                onChange={handleChange}
                placeholder="Briefly describe the project's purpose and scope..."
                className="flex min-h-[100px] w-full rounded-md border border-input bg-secondary/30 px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              />{" "}
            </div>{" "}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {" "}
              <Input
                label="Start Date"
                name="startDate"
                type="date"
                value={formData.startDate}
                onChange={handleChange}
                className="bg-secondary/30"
              />{" "}
              <Input
                label="End Date (Optional)"
                name="endDate"
                type="date"
                value={formData.endDate}
                onChange={handleChange}
                className="bg-secondary/30"
              />{" "}
            </div>{" "}
          </div>{" "}
          {message.text && (
            <div
              className={`p-4 rounded-md text-sm font-medium border ${message.type === "success" ? "bg-emerald-500/10 text-emerald-600 border-emerald-500/20" : "bg-destructive/10 text-destructive border-destructive/20"}`}
            >
              {" "}
              {message.text}{" "}
            </div>
          )}{" "}
          <div className="flex gap-4 pt-4">
            {" "}
            <Button
              type="submit"
              disabled={loading}
              className="flex-1 font-medium h-11"
              size="lg"
            >
              {" "}
              <Briefcase className="mr-2 h-4 w-4" />{" "}
              {loading ? "Creating Project..." : "Create Project"}{" "}
            </Button>{" "}
            <Link href="/admin/projects" className="flex-1">
              {" "}
              <Button
                type="button"
                variant="outline"
                className="w-full h-11"
                size="lg"
              >
                {" "}
                Cancel{" "}
              </Button>{" "}
            </Link>{" "}
          </div>{" "}
        </form>{" "}
      </Card>{" "}
    </div>
  );
}