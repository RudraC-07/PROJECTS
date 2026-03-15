import { getUserSession } from "@/lib/auth";
import { redirect } from "next/navigation";
export default async function Home() {
  const user = await getUserSession();
  if (user) {
    if (user.role === "admin") redirect("/admin/dashboard");
    if (user.role === "user") redirect("/user/dashboard");
  }
  redirect("/login");
}