# 🔰 Introduction
🌍 Welcome to Project Data Analyst!

A comprehensive analysis of global data analyst job postings from 2023.
This project aims to provide actionable insights into 💰 salary trends, 💡 most-demanded skills, and 🧠 the optimal skill set for maximizing earning potential in the data analysis field.

🧾 **SQL queries?** Check them out here: [project_sql folder](/project_sql/) 

# 📝 Background
## 🧭 About This Project  

This project began with one simple goal — to **decode the data analyst job market**.  
Instead of guessing which skills pay the most or appear most often, I wanted to **let the data speak for itself**.  

Using real job posting data from my **SQL course**, I explored a dataset filled with insights on job titles, salaries, locations, and the skills employers value most.  

Through a series of carefully designed SQL queries, I set out to uncover:  
- 💼 Which data analyst roles offer the **highest salaries**  
- 🧠 The **skills** that top-paying jobs consistently demand  
- 📊 The **most in-demand** tools and technologies overall  
- 💰 Which skills are **linked to higher earning potential**  
- 🎯 And ultimately, the **optimal skill set** for anyone aiming to thrive in the data analytics field  

In short, this project turns curiosity into clarity — helping both aspiring and experienced analysts navigate their career paths with **data-driven confidence**.

# 🛠️ Tools I Used

To explore the data analyst job market in depth, I leveraged a set of powerful tools to streamline analysis, management, and collaboration:  

- **💾 SQL:** The core of my analysis, allowing me to query datasets and extract valuable insights.  
- **🐘 PostgreSQL:** The database management system used to store, manage, and process job posting data efficiently.  
- **💻 Visual Studio Code:** My main workspace for writing and running SQL queries, organizing files, and maintaining a smooth workflow.  
- **🌐 Git & GitHub:** For version control, tracking project progress, and sharing SQL scripts and findings with the community.  
- **🤖 ChatGPT:** Assisted in brainstorming approaches, refining SQL queries, and drafting clear explanations for the project.  

# 📈 The Analysis
For this project, each SQL query was crafted to uncover a unique insight into the data analyst job market. Here’s the approach I took to answer each key question:

## 📊 1.Top Paying Data Analyst Jobs

The top paying job postings from the 2023 database show a wide range in potential earnings for data analysts, with a clear premium for senior-level and specialized roles.   

``` sql
SELECT
    job_id,
    job_title_short,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type, 
    salary_year_avg,
    job_posted_date
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
LIMIT  10;
```
### 💡 Key Insights
- **💰 Outlier Salary:** The highest reported salary is an exceptional **$650,000** for a Data Analyst role at Mantys, making it a significant outlier.  
- **🧑‍💼 Seniority Premium:** Senior and specialized titles (e.g., Director, Principal) drive the highest salaries, with top roles exceeding **$336,000**.  
- **🏆 Lucrative Top Tier:** The average annual salary among the top 10 highest-paying postings is approximately **$264,506**, highlighting a clearly lucrative top tier in the market.

![top_paying_jobs](/graphs/top%20paying.png)
*Bar chart illustrating the top 10 highest data analyst salaries, created using results derived from my SQL queries with assistance from ChatGPT.*

## 💼 2. Skills for Top Paying Jobs
The analysis of the top-paying job postings reveals the essential technical toolkit for maximizing earning potential in the data analyst field.
``` sql
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
```
### 💡 Key Insights  

- **💻 Core Languages:** SQL and Python are the most essential skills, appearing in the majority of top-paying job postings (**8** and **7** mentions, respectively).  
- **📊 Visualization Demand:** Tableau is highly valued (**6** mentions), reflecting the strong need for data communication and visualization skills.  
- **☁️ Future-Proofing:** Proficiency in cloud and big data tools like **Snowflake** and **Azure** is becoming increasingly important for securing the highest-paying roles.  
![skills for top paying jobs](/graphs/top_skills.png)

*Bar chart showing the most frequent skills among the top 10 best-paying data analyst jobs, generated from SQL query insights with ChatGPT’s help.*

## 🔍 3. In-Demand Skills for Data Analysts  
This query identified the skills most frequently mentioned in data analyst job postings, highlighting the areas where demand is highest and guiding focus toward the most valuable competencies in the market.  
```sql
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
```
### 💡 Key Insights  

- **🗄️ SQL** and **📊 Excel** form the foundation of data analysis, appearing in the highest number of job postings — **92,628** and **67,031**, respectively.  
- **🐍 Python** stands out as the most in-demand programming language, featured in **57,326** job listings.  
- Together, these three skills — database querying, spreadsheet proficiency, and programming — make up the **core skill set** for thriving in the data analytics job market.

| **Skill**   | **Demand Count**|
|---------|-------------|
| SQL      | 92,628      |
| Excel    | 67,031      |
| Python   | 57,326      |
| Tableau  | 46,554      |
| Power BI | 39,468      |

*Top 5 In-Demand Skills for Data Analysts Table.*

## 💰 4. Skills Based on Salary  

Analyzing the average salaries linked to various skills revealed which competencies are associated with the highest-paying data analyst roles.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim 
    ON Job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    --AND job_work_from_home = TRUE -- optional to see only work from home results.
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```
### 💡 Key Insights  

- **🔧 Highly Specialized Skills:** The highest-paying skills tend to be niche, often related to development, blockchain, and DevOps.  
- **💎 Niche Premium:** Extremely specialized technologies boost average salaries, e.g., **SVN** ($400,000) and **Solidity** (Blockchain, $179,000).  
- **🤖 Dev/ML Over Analytics:** Core skills driving high pay are focused on Machine Learning infrastructure or development (e.g., **DataRobot**, **Golang**, **Terraform**), pushing average salaries into the **mid-$150k** range.   

| **Skill**       | **Avg Salary (USD)** |
|------------|----------------|
| SVN        | $400,000       |
| Solidity   | $179,000       |
| Couchbase  | $160,515       |
| DataRobot  | $155,486       |
| Golang     | $155,000       |
| MXNet      | $149,000       |
| dplyr      | $147,633       |
| VMware     | $147,500       |
| Terraform  | $146,734       |
| Twilio     | $138,500       |

*Average salaries for the top 10 highest-paying skills in data analyst roles, based on SQL query results and analysis.*

## 🎯 5. Most Optimal Skills to Learn  

By combining insights from both demand and salary data, this query identifies skills that are not only highly sought after but also command higher salaries, providing a strategic roadmap for skill development in the data analyst field.
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim 
    ON Job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id
--HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
### 💡 Key Insights  

- **💎 Highest Pay is Niche:** **PySpark** ($208,172) commands the highest average salary, followed by **Bitbucket** ($189,154), showing that advanced big data processing and specific DevOps version control skills offer the largest salary premiums.  
- **🤖 Machine Learning Infrastructure Premium:** Skills related to ML platforms and data management, such as **DataRobot**, **Couchbase**, and **Watson**, cluster around the **$155k–$160k** range, highlighting the value of tools that productionize data science efforts.  
- **📊 High-Demand, High-Value Core:** **Pandas** (9 mentions, $151,821) and **Databricks** (10 mentions, $141,906) are the most in-demand skills in this top-paying set. Their combination of high demand and high salary makes them particularly valuable for career growth.    

| **Skill**        | **Demand Count** | **Avg Salary (USD)** |
|-------------|-------------|----------------|
| PySpark      | 2           | $208,172       |
| Bitbucket    | 2           | $189,154       |
| Watson       | 1           | $160,515       |
| Couchbase    | 1           | $160,515       |
| DataRobot    | 1           | $155,486       |
| GitLab       | 3           | $154,500       |
| Swift        | 2           | $153,750       |
| Jupyter      | 3           | $152,776       |
| Pandas       | 9           | $151,821       |
| Elasticsearch| 1           | $145,000       |

*Top-paying and most in-demand skills for data analysts, showing both job posting frequency and average salary based on SQL query results.*

# 🧠 What I Learned  
- **🌍 Market Insights:** Understanding the global data analyst job market, including top-paying roles, most in-demand skills, and salary trends.  
- **💻 SQL & Data Analysis:** Strengthened my SQL skills by writing complex queries to extract meaningful insights from real-world job posting data.  
- **🎯 Skill Prioritization:** Learned which combination of technical skills (SQL, Python, Excel, Tableau, cloud & ML tools) maximizes both demand and salary.  
- **📊 Visualization & Communication:** Gained experience in visualizing data trends effectively, making insights easy to interpret for strategic decision-making.  
- **🧠 Critical Thinking:** Developed the ability to combine multiple datasets and perspectives to identify optimal skills for career growth.

# ✅ Conclusion  

This project provided a comprehensive overview of the data analyst job market in 2023. By combining demand, salary, and specialization insights, I identified:  

- **💎 Skills** that are both highly sought after and high paying.  
- **🔧 Niche and advanced technologies** that offer significant salary premiums.  
- **📈 A strategic skill set** for aspiring data analysts to maximize career growth and marketability.  

Overall, this analysis demonstrates how **data-driven approaches** can guide career decisions, helping professionals focus on skills that truly matter in the competitive data analytics landscape.

### 📝 Closing Thoughts  

This project not only strengthened my **💻 SQL skills** but also provided valuable insights into the global data analyst job market. The findings offer guidance for prioritizing skill development and targeting the most promising job opportunities.  

By focusing on **📊 high-demand, high-salary skills**, aspiring data analysts can better position themselves in a competitive landscape. This exploration also underscores the importance of **🧠 continuous learning** and staying adaptable to emerging trends in the field of data analytics.

# END 👋🚪🔚