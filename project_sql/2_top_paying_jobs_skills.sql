/*
Question: What are the top-paying data analyst jobs, and what skills are required?
- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title_short,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT  10
)
SELECT 
    top_paying_jobs.*,
    skills 
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
        salary_year_avg DESC;


/*
Insights
SQL, Python, and Tableau dominate — confirming they’re core to top-paying Data Analyst roles.
R still appears in several listings, showing demand for statistical and data modeling skills.
Cloud and data warehousing tools like Snowflake and Azure are valued in higher-paying positions.
Version control and collaboration tools (GitLab, Bitbucket, Confluence, Atlassian) are also expected — suggesting 
these roles involve teamwork and production data workflows.
Excel remains relevant, even for senior or high-paying roles.
*/
