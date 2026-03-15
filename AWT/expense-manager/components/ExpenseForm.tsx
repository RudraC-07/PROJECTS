"use client";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import Link from "next/link";
import { ArrowLeft, Wallet } from "lucide-react";
export function ExpenseForm({
  role,
  peoples = [],
}: {
  role: string;
  peoples?: any[];
}) {
  const router = useRouter();
  const [categories, setCategories] = useState([]);
  const [subCategories, setSubCategories] = useState([]);
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ type: "", text: "" });
  const [formData, setFormData] = useState({
    amount: "",
    categoryId: "",
    subCategoryId: "",
    projectId: "",
    date: new Date().toISOString().split("T")[0],
    detail: "",
    description: "",
    peopleId: role === "admin" ? "" : "self",
  });
  useEffect(() => {
    fetchCategories();
    fetchProjects();
  }, []);
  const fetchCategories = async () => {
    try {
      const res = await fetch("/api/categories");
      const data = await res.json();
      if (res.ok) setCategories(data);
    } catch (err) {
      console.error("Failed to fetch categories");
    }
  };
  const fetchProjects = async () => {
    try {
      const res = await fetch("/api/projects");
      const data = await res.json();
      if (res.ok) setProjects(data);
    } catch (err) {
      console.error("Failed to fetch projects");
    }
  };
  const handleChange = (e: any) => {
    const { name, value } = e.target;
    if (name === "categoryId") {
      const selectedCat: any = categories.find(
        (c: any) => c.categoryid.toString() === value,
      );
      setSubCategories(selectedCat ? selectedCat.sub_categories : []);
      setFormData({ ...formData, categoryId: value, subCategoryId: "" });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };
  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: "", text: "" });
    try {
      const res = await fetch("/api/expenses", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.message);
      setMessage({ type: "success", text: "Expense recorded successfully!" });
      setTimeout(() => {
        router.push(role === "admin" ? "/admin/dashboard" : "/user/dashboard");
        router.refresh();
      }, 1500);
    } catch (err: any) {
      setMessage({ type: "error", text: err.message });
      setLoading(false);
    }
  };
  const selectClasses =
    "flex h-10 w-full rounded-xl border border-border bg-background px-3 py-2 text-[12.5px] font-medium text-foreground ring-offset-background focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-primary/40 disabled:cursor-not-allowed disabled:opacity-50";
  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center gap-4">
        <Link href={role === "admin" ? "/admin/dashboard" : "/user/dashboard"}>
          <Button variant="ghost" size="icon" className="rounded-full">
            <ArrowLeft className="h-5 w-5" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-semibold">Add Expense</h1>
          <p className="text-muted-foreground text-sm">
            Log a new expense for your project.
          </p>
        </div>
      </div>
      <Card className="shadow-xl p-8">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Input
              label="Amount ($)"
              name="amount"
              type="number"
              step="0.01"
              required
              prefix="$"
              value={formData.amount}
              onChange={handleChange}
              placeholder="0.00"
            />
            <div className="space-y-1.5">
              <label className="text-[10px] font-medium uppercase tracking-[0.15em] leading-none text-primary/70 ml-1">
                Category
              </label>
              <select
                name="categoryId"
                value={formData.categoryId}
                onChange={handleChange}
                className={selectClasses}
              >
                <option value="">Select Category</option>
                {categories.map((cat: any) => (
                  <option key={cat.categoryid} value={cat.categoryid}>
                    {cat.categoryname}
                  </option>
                ))}
              </select>
            </div>
            <div className="space-y-1.5">
              <label className="text-[10px] font-medium uppercase tracking-[0.15em] leading-none text-primary/70 ml-1">
                Project
              </label>
              <select
                name="projectId"
                value={formData.projectId}
                onChange={handleChange}
                className={selectClasses}
              >
                <option value="">Select Project</option>
                {projects.map((proj: any) => (
                  <option key={proj.projectid} value={proj.projectid}>
                    {proj.projectname}
                  </option>
                ))}
              </select>
            </div>
            <div className="space-y-1.5">
              <label className="text-[10px] font-medium uppercase tracking-[0.15em] leading-none text-primary/70 ml-1">
                Sub Category
              </label>
              <select
                name="subCategoryId"
                value={formData.subCategoryId}
                onChange={handleChange}
                disabled={!formData.categoryId}
                className={selectClasses}
              >
                <option value="">
                  {formData.categoryId
                    ? "Select Sub Category"
                    : "Select Category First"}
                </option>
                {subCategories.map((sub: any) => (
                  <option key={sub.subcategoryid} value={sub.subcategoryid}>
                    {sub.subcategoryname}
                  </option>
                ))}
              </select>
            </div>
            <Input
              label="Date"
              name="date"
              type="date"
              required
              value={formData.date}
              onChange={handleChange}
            />
            <Input
              label="Expense Detail"
              name="detail"
              value={formData.detail}
              onChange={handleChange}
              placeholder="e.g. Grocery shopping"
            />
          </div>
          {role === "admin" && peoples.length > 0 && (
            <div className="space-y-1.5">
              <label className="text-[10px] font-medium uppercase tracking-[0.15em] leading-none text-primary/70 ml-1">
                Allocate to Person
              </label>
              <select
                name="peopleId"
                value={formData.peopleId}
                onChange={handleChange}
                className={selectClasses}
              >
                <option value="0">Me (Admin)</option>
                {peoples.map((p: any) => (
                  <option key={p.peopleid} value={p.peopleid}>
                    {p.peoplename}
                  </option>
                ))}
              </select>
            </div>
          )}
          <Input
            label="Additional Description (Optional)"
            name="description"
            value={formData.description}
            onChange={handleChange}
            placeholder="Notes about this expense..."
          />
          {message.text && (
            <div
              className={`p-4 rounded-xl text-sm font-medium border ${
                message.type === "success"
                  ? "bg-emerald-500/10 text-emerald-600 border-emerald-500/20"
                  : "bg-rose-500/10 text-rose-400 border-rose-500/20"
              }`}
            >
              {message.text}
            </div>
          )}
          <div className="flex gap-4 pt-4">
            <Button
              type="submit"
              disabled={loading}
              className="flex-1 font-medium h-11"
              size="lg"
            >
              <Wallet className="mr-2 h-4 w-4" />
              {loading ? "Recording..." : "Save Expense"}
            </Button>
            <Link
              href={role === "admin" ? "/admin/dashboard" : "/user/dashboard"}
              className="flex-1"
            >
              <Button
                type="button"
                variant="outline"
                className="w-full h-11"
                size="lg"
              >
                Cancel
              </Button>
            </Link>
          </div>
        </form>
      </Card>
    </div>
  );
}