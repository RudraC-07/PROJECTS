'use client';
import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';
import { Briefcase, Calendar } from 'lucide-react';
export default function UserProjectsPage() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    fetchProjects();
  }, []);
  const fetchProjects = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/projects');
      const data = await res.json();
      if (res.ok) setProjects(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">My Projects</h1>
        <p className="text-muted-foreground mt-1">View projects you are currently assigned to.</p>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {loading ? (
          <div className="col-span-full py-20 text-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground font-medium">Loading your projects...</p>
          </div>
        ) : projects.length > 0 ? (
          projects.map((project: any) => (
            <Card key={project.projectid} className="hover:shadow-lg border-border/50 group">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-primary-foreground mb-4">
                <Briefcase className="h-5 w-5" />
              </div>
              <h3 className="text-lg font-semibold text-foreground group-hover:text-primary">
                {project.projectname}
              </h3>
              <p className="text-sm text-muted-foreground mt-2 line-clamp-2 min-h-[40px]">
                {project.projectdetail || project.description || 'Assigned company project.'}
              </p>
              <div className="mt-6 pt-4 border-t border-border flex items-center justify-between text-[11px] text-muted-foreground font-medium">
                <div className="flex items-center gap-1">
                  <Calendar className="h-3.5 w-3.5" />
                  {project.projectstartdate ? new Date(project.projectstartdate).toLocaleDateString('en-GB') : 'Active'}
                </div>
                <Link href={`/user/projects/${project.projectid}`} className="font-medium text-primary hover:underline">
                  View Details →
                </Link>
              </div>
            </Card>
          ))
        ) : (
          <div className="col-span-full py-20 text-center border-2 border-dashed rounded-xl bg-secondary/5 mt-4">
            <p className="text-muted-foreground font-medium">No projects assigned yet.</p>
          </div>
        )}
      </div>
    </div>
  );
}