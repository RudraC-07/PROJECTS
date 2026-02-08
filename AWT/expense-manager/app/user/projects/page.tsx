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
    <div className="space-y-6 animate-in fade-in duration-500">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Assigned Projects</h1>
        <p className="text-muted-foreground mt-1">Review the company projects you are currently contributing to.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {loading ? (
          <div className="col-span-full py-20 text-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading projects...</p>
          </div>
        ) : projects.length > 0 ? (
          projects.map((project: any) => (
            <Card key={project.projectid} className="hover:shadow-lg transition-all border-border/50 group">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-primary-foreground transition-colors mb-4">
                <Briefcase className="h-5 w-5" />
              </div>
              <h3 className="text-lg font-bold text-foreground group-hover:text-primary transition-colors">
                {project.projectname}
              </h3>
              <p className="text-sm text-muted-foreground mt-2 line-clamp-2">
                {project.projectdetail || project.description || 'Company project.'}
              </p>
              
              <div className="mt-6 pt-4 border-t border-border flex items-center justify-between text-xs text-muted-foreground">
                <div className="flex items-center gap-1">
                  <Calendar className="h-3.5 w-3.5" />
                  {project.projectstartdate ? new Date(project.projectstartdate).toLocaleDateString('en-GB') : 'Active'}
                </div>
                <span className="font-bold text-primary">Active</span>
              </div>
            </Card>
          ))
        ) : (
          <div className="col-span-full py-20 text-center border-2 border-dashed rounded-xl bg-secondary/5 mt-4">
            <p className="text-muted-foreground">No projects assigned yet.</p>
          </div>
        )}
      </div>
    </div>
  );
}
