"use client";

import { AlertTriangle, CheckCircle, RefreshCcw, Activity, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";

interface ResultCardProps {
  result: {
    prediction: number;
    probability_no_disease: number;
    probability_disease: number;
  };
  inputData: any;
  onReset: () => void;
}

export default function ResultCard({ result, inputData, onReset }: ResultCardProps) {
  const riskPercentage = result.probability_disease * 100;

  // Determine Risk Level
  let riskLevel = "low";
  let colorScheme = "primary"; // Default green/primary
  let statusText = "Low Risk Profile";
  let headline = "Health Metrics Within Range";
  let description = "Your clinical parameters align with a healthy cardiovascular profile. Continue maintaining your active lifestyle and regular check-ups.";
  let Icon = CheckCircle;
  let gradientColor = "from-primary/20";
  
  if (riskPercentage > 55) {
    riskLevel = "high";
    colorScheme = "destructive";
    statusText = "High Risk Detected";
    headline = "Medical Attention Recommended";
    description = "Our analysis indicates varying levels of potential cardiovascular risk based on your inputs. We strongly recommend consulting a cardiologist for a comprehensive evaluation.";
    Icon = AlertTriangle;
    gradientColor = "from-destructive/20";
  } else if (riskPercentage >= 46) {
    riskLevel = "moderate";
    colorScheme = "yellow-500";
    statusText = "Moderate Risk Profile";
    headline = "Caution Recommended";
    description = "Your results suggest a moderate risk. It is advisable to monitor your health closely and consult with a healthcare provider for preventive measures.";
    Icon = AlertTriangle;
    gradientColor = "from-yellow-500/20";
  }

  // Helper for dynamic classes since we can't fully interpolate tailwind classes sometimes inside complex strings
  const getThemeClasses = () => {
    switch (riskLevel) {
      case "high":
        return {
          card: "border-destructive/50 bg-destructive/5",
          text: "text-destructive",
          bgBadge: "bg-destructive/10 border-destructive/20 text-destructive",
          icon: "text-destructive"
        };
      case "moderate":
        return {
          card: "border-yellow-500/50 bg-yellow-500/5",
          text: "text-yellow-500",
          bgBadge: "bg-yellow-500/10 border-yellow-500/20 text-yellow-500",
          icon: "text-yellow-500"
        };
      default:
        return {
          card: "border-primary/50 bg-primary/5",
          text: "text-primary",
          bgBadge: "bg-primary/10 border-primary/20 text-primary",
          icon: "text-primary"
        };
    }
  };

  const theme = getThemeClasses();
  
  // Calculate stroke dasharray for the circular progress (circumference ~ 283)
  const circumference = 283;
  const strokeDashoffset = circumference - (riskPercentage / 100) * circumference;

  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: "easeOut" }}
      className="max-w-4xl mx-auto space-y-8"
    >
      {/* Main Result Card */}
      <div className={`relative overflow-hidden rounded-3xl p-8 border ${theme.card} backdrop-blur-sm shadow-2xl`}>
        {/* Glow Effects */}
        <div className={`absolute top-0 right-0 w-[300px] h-[300px] bg-gradient-to-br ${gradientColor} to-transparent rounded-full blur-[80px] -z-10`} />
        
        <div className="flex flex-col md:flex-row items-center justify-center gap-12 md:pl-8">
            
            {/* Visual Indicator (Left) */}
            <div className="relative shrink-0">
                 {/* Circular Progress */}
                <div className="relative w-48 h-48 flex items-center justify-center">
                    <svg className="w-full h-full -rotate-90 transform" viewBox="0 0 100 100">
                        {/* Background Circle */}
                        <circle
                            className="text-muted/20"
                            strokeWidth="8"
                            stroke="currentColor"
                            fill="transparent"
                            r="45"
                            cx="50"
                            cy="50"
                        />
                        {/* Progress Circle */}
                        <motion.circle
                            className={theme.text}
                            strokeWidth="8"
                            stroke="currentColor"
                            fill="transparent"
                            r="45"
                            cx="50"
                            cy="50"
                            strokeLinecap="round"
                            initial={{ strokeDasharray: circumference, strokeDashoffset: circumference }}
                            animate={{ strokeDashoffset: strokeDashoffset }}
                            transition={{ duration: 1.5, ease: "easeOut", delay: 0.2 }}
                        />
                    </svg>
                    
                    {/* Center Icon/Text */}
                    <div className="absolute inset-0 flex flex-col items-center justify-center">
                         <Icon className={`h-10 w-10 mb-1 ${theme.icon}`} />
                         <span className={`text-3xl font-bold ${theme.text}`}>
                             {riskPercentage.toFixed(0)}%
                         </span>
                         <span className="text-xs text-muted-foreground uppercase tracking-wider font-medium">Risk Score</span>
                    </div>
                </div>
            </div>

            {/* Text Content (Right) */}
            <div className="text-center md:text-left space-y-4 flex-1">
                <div className={`inline-flex items-center gap-2 px-3 py-1 rounded-full border ${theme.bgBadge} text-sm font-bold uppercase tracking-wide`}>
                    {statusText}
                </div>
                
                <h2 className="text-3xl md:text-4xl font-bold text-foreground">
                    {headline}
                </h2>
                
                <p className="text-lg text-muted-foreground leading-relaxed">
                   {description}
                </p>
                
                <div className="flex flex-wrap gap-4 justify-center md:justify-start pt-2">
                    <div className="px-4 py-2 bg-background/50 rounded-lg border border-border/50 text-sm font-mono text-muted-foreground">
                        Model Accuracy: <span className="text-foreground font-bold">73%</span>
                    </div>
                </div>
            </div>

        </div>
      </div>

      {/* Details Grid */}
      <div className="grid md:grid-cols-2 gap-6">
        <div className="bg-muted/10 border border-border rounded-xl p-6 backdrop-blur-sm shadow-sm">
           <div className="flex items-center gap-2 mb-6 border-b border-border/50 pb-3">
               <Activity className="text-chart-2 h-5 w-5" />
               <h3 className="font-semibold text-foreground">Vitals & Measurements</h3>
           </div>
           <dl className="grid grid-cols-2 gap-y-4 gap-x-8">
                <SummaryItem label="Age" value={`${inputData.age} Years`} />
                <SummaryItem label="BMI" value={(parseFloat(inputData.weight) / Math.pow(parseFloat(inputData.height)/100, 2)).toFixed(1)} />
                <SummaryItem label="Systolic BP" value={inputData.ap_hi} highlighted={parseInt(inputData.ap_hi) > 130} />
                <SummaryItem label="Diastolic BP" value={inputData.ap_lo} highlighted={parseInt(inputData.ap_lo) > 85} />
                <SummaryItem label="Cholesterol" value={["Normal", "Above Normal", "High"][parseInt(inputData.cholesterol)-1]} highlighted={parseInt(inputData.cholesterol) > 1} />
                <SummaryItem label="Glucose" value={["Normal", "Above Normal", "High"][parseInt(inputData.gluc)-1]} highlighted={parseInt(inputData.gluc) > 1} />
           </dl>
        </div>

        <div className="bg-muted/10 border border-border rounded-xl p-6 backdrop-blur-sm shadow-sm">
            <div className="flex items-center gap-2 mb-6 border-b border-border/50 pb-3">
                <CheckCircle className="text-chart-4 h-5 w-5" />
                <h3 className="font-semibold text-foreground">Lifestyle Factors</h3>
            </div>
            <dl className="space-y-4">
                    <div className="flex justify-between items-center">
                        <dt className="text-muted-foreground">Physical Activity</dt>
                        <dd className={`font-medium ${inputData.active === "1" ? "text-primary" : "text-muted-foreground"}`}>
                            {inputData.active === "1" ? "Active" : "Sedentary"}
                        </dd>
                    </div>
                    <div className="flex justify-between items-center">
                        <dt className="text-muted-foreground">Smoking Status</dt>
                        <dd className={`font-medium ${inputData.smoke === "1" ? "text-destructive" : "text-primary"}`}>
                            {inputData.smoke === "1" ? "Smoker" : "Non-Smoker"}
                        </dd>
                    </div>
                    <div className="flex justify-between items-center">
                        <dt className="text-muted-foreground">Alcohol Consumption</dt>
                        <dd className={`font-medium ${inputData.alco === "1" ? "text-orange-500" : "text-primary"}`}>
                            {inputData.alco === "1" ? "Yes" : "No"}
                        </dd>
                    </div>
            </dl>
        </div>
      </div>

      <div className="flex justify-center pt-8 pb-4">
        <Button onClick={onReset} className="px-12 h-14 text-lg bg-primary hover:bg-primary/90 text-primary-foreground transition-all duration-300 font-bold shadow-xl hover:shadow-primary/25 hover:-translate-y-1 rounded-full group">
            <RefreshCcw className="mr-2 h-5 w-5 group-hover:rotate-180 transition-transform duration-500" /> Start New Assessment
        </Button>
      </div>
    </motion.div>
  );
}

function SummaryItem({ label, value, highlighted = false }: { label: string, value: string | number, highlighted?: boolean }) {
  return (
    <div>
      <dt className="text-muted-foreground text-xs uppercase tracking-wider mb-1">{label}</dt>
      <dd className={`font-bold text-lg ${highlighted ? 'text-destructive' : 'text-foreground'}`}>{value}</dd>
    </div>
  );
}
