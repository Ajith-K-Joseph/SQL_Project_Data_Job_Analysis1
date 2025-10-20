/*
Question: What are the most in-demand skills for data analysts?
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim 
    ON Job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    --AND job_country = 'United States' -- optional to see jobs only from the US
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;

/*
Insights
The data reveals a clear prioritization of foundational data tools and query languages over programming and visualization skills. 
SQL is the most demanded skill by a significant margin ($\mathbf{92,628}$ job postings), followed by Excel ($\mathbf{67,031}$). 
This indicates that employers highly value professionals who can efficiently access, manage, and manipulate structured data 
before moving on to advanced analytics or visualization with tools like Python, Tableau, and Power BI.

Result:
[
  {
    "skills": "sql",
    "demand_count": "92628"
  },
  {
    "skills": "excel",
    "demand_count": "67031"
  },
  {
    "skills": "python",
    "demand_count": "57326"
  },
  {
    "skills": "tableau",
    "demand_count": "46554"
  },
  {
    "skills": "power bi",
    "demand_count": "39468"
  }
]
*/
