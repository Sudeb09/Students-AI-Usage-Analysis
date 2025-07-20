# Analysis of Student AI Usage in Higher Education

**Author :** *Sudeb Paul*

**Date :** 20.07.2025

**Dataset Source :** *Kaggle*

**Author on Kaggle :** *Rakesh Kapilavayi*

**Dataset Name :** *AI Tool Usage by Indian College Students 2025*

**Dataset URL :** *[Link](https://www.kaggle.com/datasets/rakeshkapilavai/ai-tool-usage-by-indian-college-students-2025)*

-----

## Project Description

This project analyzes a dataset containing information on student AI usage in higher education. The goal is to explore various aspects of AI tool adoption, including usage patterns, perceptions of AI, institutional attitudes towards AI, and factors influencing willingness to pay for AI access. The analysis aims to uncover insights into how students are integrating AI into their academic lives and the broader implications for educational institutions.

-----

## Dataset

This analysis is conducted using the `StudentAIUsage` dataset, a comprehensive collection of 3614 records detailing student engagement with AI tools in higher education. Each entry encapsulates key attributes, including:

  * **Demographic Information:** Academic Stream, Year of Study, College Affiliation, and Geographic Location (State).
  * **AI Interaction Metrics:** Types of AI tools utilized, average daily usage hours, and primary use cases.
  * **Perceptual Data:** Student trust in AI tools, perceived academic impact, and overall AI awareness levels.
  * **Institutional Policies:** Indication of faculty allowance regarding AI tool usage.
  * **Preference & Commercial Intent:** Preferred AI tool and willingness to invest in AI access.
  * **Technological Infrastructure:** Primary device used for AI access and internet connectivity quality.

This rich dataset enables a multi-faceted exploration of AI adoption dynamics among students.

-----

## Data Preprocessing and Cleaning

Prior to analysis, the `StudentAIUsage` dataset underwent a crucial preprocessing phase to ensure data quality and integrity. This involved:

1.  **Duplicate Row Removal:** Identified and eliminated duplicate entries based on `Student_Name`, `College_Name`, `Stream`, and `Year_of_Study` to ensure each student's record was unique for the defined combination of attributes.
2.  **Missing Value Assessment:** Conducted a thorough check for `NULL` or empty string values across all columns to understand the completeness of the dataset. (It was observed that some `State`, `AI_Tools_Used`, `Use_Cases`, and `Preferred_AI_Tool` entries were initially missing, but this was noted for contextual understanding rather than outright removal to preserve record count given the nature of the data).

These steps were critical in preparing a clean and reliable dataset for subsequent analytical exploration.

-----

## SQL Queries and Execution Log

This section details all SQL queries executed for data creation, cleaning, and exploration, along with their respective outputs.

## 1\. Database Setup and Initial Inspection

**1.1 Table Creation**

```sql
CREATE TABLE StudentAIUsage (
    Student_Name VARCHAR(255),
    College_Name VARCHAR(255),
    Stream VARCHAR(255),
    Year_of_Study INTEGER,
    AI_Tools_Used TEXT,
    Daily_Usage_Hours REAL,
    Use_Cases TEXT,
    Trust_in_AI_Tools VARCHAR(50),
    Impact_on_Grades INTEGER,
    Do_Professors_Allow_Use VARCHAR(3),
    Preferred_AI_Tool VARCHAR(255),
    Awareness_Level INTEGER,
    Willing_to_Pay_for_Access VARCHAR(3),
    State VARCHAR(255),
    Device_Used VARCHAR(50),
    Internet_Access VARCHAR(50)
);
```

*Result: Table `StudentAIUsage` created successfully.*

**1.2 Inspecting First 5 Rows**

```sql
SELECT * FROM StudentAIUsage LIMIT 5;
```

*Result: This table displays the initial five records, illustrating the type of information captured for each student's AI usage.*

| student\_name | college\_name                                | stream     | year\_of\_study | ai\_tools\_used | daily\_usage\_hours | use\_cases                   | trust\_in\_ai\_tools | impact\_on\_grades | do\_professors\_allow\_use | preferred\_ai\_tool | awareness\_level | willing\_to\_pay\_for\_access | state        | device\_used | internet\_access |
| :------------ | :------------------------------------------- | :--------- | :-------------- | :-------------- | :------------------ | :--------------------------- | :------------------- | :----------------- | :------------------------- | :------------------ | :--------------- | :---------------------------- | :----------- | :----------- | :--------------- |
| Vivaan        | Government Ram Bhajan Rai NES College, Jashpur | Commerce   | 2               | ChatGPT         | 3.4                 | Learning new topics          | 3                    | -3                 | Yes                        | Other               | 6                | No                            | Chhattisgarh | Laptop       | Poor             |
| Aditya        | Dolphin PG Institute of BioMedical & Natural | Science    | 2               | Copilot         | 3.6                 | MCQ Practice, Projects       | 5                    | 0                  | No                         | Gemini              | 1                | No                            | Uttarakhand  | Tablet       | Poor             |
| Vihaan        | Shaheed Rajguru College of Applied Sciences for | Arts       | 2               | Copilot         | 2.9                 | Content Writing              | 5                    | 2                  | Yes                        | Gemini              | 5                | No                            | Delhi ncr    | Laptop       | High             |
| Arjun         | Roorkee College of Engineering               | Science    | 1               | Gemini          | 0.9                 | Doubt Solving, Resume Writing | 1                    | 3                  | Yes                        | Other               | 8                | Yes                           | Uttarakhand  | Laptop       | Medium           |
| Sai           | Kanya Mahavidyalaya                          | Commerce   | 2               | Gemini          | 0.8                 | Doubt Solving, Resume Writing | 2                    | -2                 | Yes                        | Gemini              | 7                | No                            | Punjab       | Laptop       | High             |


**1.3 Total Number of Records (Initial)**

```sql
SELECT COUNT(*) FROM StudentAIUsage;
```

*Result:*

```
count
------
3614
```

## 2\. Data Cleaning and Validation

**2.1 Checking for Null/Empty Values Across Columns**

```sql
SELECT
    COUNT(*) FILTER (WHERE Student_Name IS NULL) AS null_student_name,
    COUNT(*) FILTER (WHERE College_Name IS NULL) AS null_college_name,
    COUNT(*) FILTER (WHERE Stream IS NULL) AS null_stream,
    COUNT(*) FILTER (WHERE Year_of_Study IS NULL) AS null_year_of_study,
    COUNT(*) FILTER (WHERE AI_Tools_Used IS NULL OR AI_Tools_Used = '') AS null_ai_tools_used,
    COUNT(*) FILTER (WHERE Daily_Usage_Hours IS NULL) AS null_daily_usage_hours,
    COUNT(*) FILTER (WHERE Use_Cases IS NULL OR Use_Cases = '') AS null_use_cases,
    COUNT(*) FILTER (WHERE Trust_in_AI_Tools IS NULL) AS null_trust_in_ai_tools,
    COUNT(*) FILTER (WHERE Impact_on_Grades IS NULL) AS null_impact_on_grades,
    COUNT(*) FILTER (WHERE Do_Professors_Allow_Use IS NULL) AS null_professors_allow_use,
    COUNT(*) FILTER (WHERE Preferred_AI_Tool IS NULL OR Preferred_AI_Tool = '') AS null_preferred_ai_tool,
    COUNT(*) FILTER (WHERE Awareness_Level IS NULL) AS null_awareness_level,
    COUNT(*) FILTER (WHERE Willing_to_Pay_for_Access IS NULL) AS null_willing_to_pay,
    COUNT(*) FILTER (WHERE State IS NULL) AS null_state,
    COUNT(*) FILTER (WHERE Device_Used IS NULL) AS null_device_used,
    COUNT(*) FILTER (WHERE Internet_Access IS NULL) AS null_internet_access
FROM StudentAIUsage;
```

**2.2 Identifying Duplicate Records**

```sql
SELECT
    Student_Name,
    College_Name,
    Stream,
    Year_of_Study,
    COUNT(*) AS duplicate_count
FROM
    StudentAIUsage
GROUP BY
    Student_Name,
    College_Name,
    Stream,
    Year_of_Study
HAVING
    COUNT(*) > 1;
```

**2.3 Deleting Duplicate Records**

```sql
DELETE FROM StudentAIUsage
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT ctid,
                ROW_NUMBER() OVER (
                    PARTITION BY Student_Name, College_Name, Stream, Year_of_Study
                    ORDER BY Student_Name
                ) AS rn
        FROM StudentAIUsage
    ) sub
    WHERE rn > 1
);
```

**2.4 Total Number of Records After Cleaning**

```sql
SELECT COUNT(*) FROM StudentAIUsage;
```

*Result:*

```
count
------
3487
```

## 3\. Exploratory Data Analysis - Demographics & Overall Usage

**3.1 Distribution of Students by Year of Study**

```sql
SELECT year_of_study, COUNT(year_of_study) AS students_per_year
FROM StudentAIUsage
GROUP BY year_of_study;
```

*Result:*

```
year_of_study | students_per_year
--------------|------------------
1             | 874
3             | 843
4             | 839
2             | 931
```

**3.2 Top 5 Colleges in AI Adoption (Active Users)**

```sql
SELECT College_Name, COUNT(*) AS Active_Users
FROM StudentAIUsage
WHERE Daily_Usage_Hours > 0
GROUP BY College_Name
ORDER BY Active_Users DESC
LIMIT 5;
```

*Result:*

```
college_name                     | active_users
---------------------------------|-------------
National Institute of Technology | 175
Indian Institute of Technology   | 129
Indian Institute of Information Technology | 59
Indian Institute of Management   | 56
Institute of Hotel Management    | 19
```

**3.3 States with the Highest AI Tool Adoption**

```sql
SELECT
    state,
    COUNT(*) AS Total_students
FROM StudentAIUsage
GROUP BY state
ORDER BY Total_students DESC;
```

*Result:*

```
state            | total_students
-----------------|---------------
NULL             | 1515
Maharashtra      | 106
Uttar pradesh    | 94
Rajasthan        | 93
Punjab           | 91
Kerala           | 88
Andhra pradesh   | 87
Karnataka        | 87
Tamil nadu       | 85
Gujarat          | 84
Chhattisgarh     | 81
Assam            | 79
Madhya pradesh   | 79
West bengal      | 79
Haryana          | 76
Bihar            | 75
Uttarakhand      | 71
Delhi ncr        | 68
Telangana        | 64
Orissa           | 59
Jammu            | 58
Himachal pradesh | 56
Jharkhand        | 52
Chandigarh       | 41
Arunachal pradesh| 35
Meghalaya        | 34
Goa              | 32
Nagaland         | 24
Puducherry       | 23
Manipur          | 19
Tripura          | 19
Sikkim           | 16
Mizoram          | 10
Andaman          | 5
Dadra            | 2
```

**3.4 Average Daily Usage Hours (Overall)**

```sql
SELECT ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS avg_daily_usage_hours
FROM StudentAIUsage;
```

*Result:*

```
avg_daily_usage_hours
---------------------
2.6
```

## 4\. Exploratory Data Analysis - Tool Preferences & Usage Details

**4.1 Top Most Preferred AI Tools**

```sql
SELECT
    Preferred_AI_Tool,
    COUNT(*) AS Preference_Count
FROM StudentAIUsage
GROUP BY Preferred_AI_Tool
ORDER BY Preference_Count DESC;
```

*Result:*

```
preferred_ai_tool | preference_count
------------------|-----------------
Gemini            | 825
ChatGPT           | 824
Copilot           | 807
Other             | 723
Claude            | 157
Bard              | 151
```

**4.2 Average Daily Usage Hours by Academic Stream**

```sql
SELECT
    stream,
    ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS avg_daily_usage_hours
FROM StudentAIUsage
GROUP BY stream
ORDER BY avg_daily_usage_hours DESC;
```

*Result:*

```
stream           | avg_daily_usage_hours
-----------------|----------------------
Pharmacy         | 2.7
Arts             | 2.7
Law              | 2.7
Commerce         | 2.7
Science          | 2.7
Agriculture      | 2.6
Management       | 2.5
Medical          | 2.4
Hotel-management | 2.4
Engineering      | 2.3
```

**4.3 Average Daily Usage Hours by Year of Study**

```sql
SELECT
    Year_of_Study,
    ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS Avg_Usage
FROM StudentAIUsage
GROUP BY Year_of_Study
ORDER BY Year_of_Study;
```

*Result:*

```
year_of_study | avg_usage
--------------|----------
1             | 2.5
2             | 2.6
3             | 2.6
4             | 2.6
```

## 5\. Exploratory Data Analysis - Perceptions & Institutional Aspects

**5.1 How Trust in AI Tools Varies by Stream**

```sql
SELECT Stream, Trust_in_AI_Tools, COUNT(*) AS NumberOfStudents
FROM StudentAIUsage
GROUP BY Stream, Trust_in_AI_Tools
ORDER BY Stream, NumberOfStudents DESC;
```

*Result:*

```
stream           | trust_in_ai_tools | numberofstudents
-----------------|-------------------|-----------------
Agriculture      | 3                 | 57
Agriculture      | 2                 | 55
Agriculture      | 5                 | 54
Agriculture      | 4                 | 53
Agriculture      | 1                 | 42
Arts             | 2                 | 95
Arts             | 5                 | 95
Arts             | 1                 | 79
Arts             | 4                 | 72
Arts             | 3                 | 66
Commerce         | 1                 | 84
Commerce         | 3                 | 79
Commerce         | 5                 | 74
Commerce         | 2                 | 68
Commerce         | 4                 | 59
Engineering      | 2                 | 125
Engineering      | 3                 | 94
Engineering      | 4                 | 85
Engineering      | 5                 | 83
Engineering      | 1                 | 67
Hotel-management | 3                 | 72
Hotel-management | 2                 | 66
Hotel-management | 4                 | 62
Hotel-management | 1                 | 61
Hotel-management | 5                 | 53
Law              | 2                 | 59
Law              | 5                 | 56
Law              | 4                 | 49
Law              | 3                 | 43
Law              | 1                 | 38
Management       | 5                 | 99
Management       | 1                 | 94
Management       | 4                 | 67
Management       | 3                 | 56
Management       | 2                 | 54
Medical          | 3                 | 60
Medical          | 4                 | 58
Medical          | 1                 | 56
Medical          | 5                 | 56
Medical          | 2                 | 50
Pharmacy         | 2                 | 64
Pharmacy         | 5                 | 57
Pharmacy         | 4                 | 52
Pharmacy         | 3                 | 39
Pharmacy         | 1                 | 37
Science          | 5                 | 143
Science          | 1                 | 123
Science          | 3                 | 102
Science          | 4                 | 93
Science          | 2                 | 82
```

**5.2 Overall Student Trust in AI Tools**

```sql
SELECT
    Trust_in_AI_Tools,
    COUNT(*) AS Trust_rating
FROM StudentAIUsage
GROUP BY Trust_in_AI_Tools
ORDER BY Trust_in_AI_Tools DESC;
```

*Result:*

```
trust_in_ai_tools | trust_rating
------------------|-------------
5                 | 770
4                 | 650
3                 | 668
2                 | 718
1                 | 681
```

**5.3 Awareness Level Correlating with Usage Hours**

```sql
SELECT Awareness_Level, ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS Avg_Usage
FROM StudentAIUsage
GROUP BY Awareness_Level
ORDER BY Awareness_Level;
```

*Result:*

```
awareness_level | avg_usage
----------------|----------
1               | 2.7
2               | 2.4
3               | 2.4
4               | 2.9
5               | 2.6
6               | 2.5
7               | 2.6
8               | 2.4
9               | 2.6
10              | 2.6
```

**5.4 Do Professors Allow AI Usage (Student Perspective)?**

```sql
SELECT
    Do_Professors_Allow_Use,
    COUNT(*) AS Student_Count
FROM StudentAIUsage
GROUP BY Do_Professors_Allow_Use;
```

*Result:*

```
do_professors_allow_use | student_count
------------------------|--------------
No                      | 1817
Yes                     | 1670
```

## 6\. Exploratory Data Analysis - Technical Access

**6.1 Device Most Commonly Used for Accessing AI Tools**

```sql
SELECT Device_Used, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Device_Used
ORDER BY Count DESC;
```

*Result:*

```
device_used | count
------------|------
Laptop      | 1286
Tablet      | 1130
Mobile      | 1071
```

**6.2 Internet Access Quality Impact on Daily AI Usage Hours**

```sql
SELECT Internet_Access, ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS Avg_Usage
FROM StudentAIUsage
GROUP BY Internet_Access;
```

*Result:*

```
internet_access | avg_usage
----------------|----------
High            | 2.5
Poor            | 2.5
Medium          | 2.6
```

## 7\. Exploratory Data Analysis - Willingness to Pay & Preferences

**7.1 Are Students Willing to Pay for Access to AI Tools?**

```sql
SELECT Willing_to_Pay_for_Access, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Willing_to_Pay_for_Access;
```

*Result:*

```
willing_to_pay_for_access | count
--------------------------|------
No                        | 1753
Yes                       | 1734
```

**7.2 Which AI Tools are Most Preferred Among Those Willing to Pay?**

```sql
SELECT Preferred_AI_Tool, COUNT(*) AS Count
FROM StudentAIUsage
WHERE Willing_to_Pay_for_Access = 'Yes'
GROUP BY Preferred_AI_Tool
ORDER BY Count DESC;
```

*Result:*

```
preferred_ai_tool | count
------------------|------
Copilot           | 410
Gemini            | 399
ChatGPT           | 399
Other             | 363
Claude            | 84
Bard              | 79
```

**7.3 Which States Show Highest Willingness to Pay for AI Access?**

```sql
SELECT State, COUNT(*) AS Willing_Count
FROM StudentAIUsage
WHERE Willing_to_Pay_for_Access = 'Yes'
GROUP BY State
ORDER BY Willing_Count DESC;
```

*Result:*

```
state            | willing_count
-----------------|--------------
NULL             | 729
Maharashtra      | 57
Rajasthan        | 51
Uttar pradesh    | 48
Gujarat          | 47
Karnataka        | 47
Chhattisgarh     | 44
Assam            | 44
West bengal      | 44
Tamil nadu       | 43
Kerala           | 41
Madhya pradesh   | 41
Punjab           | 40
Bihar            | 40
Uttarakhand      | 38
Andhra pradesh   | 37
Delhi ncr        | 35
Jharkhand        | 34
Haryana          | 33
Jammu            | 33
Orissa           | 32
Telangana        | 30
Himachal pradesh | 24
Chandigarh       | 17
Meghalaya        | 16
Arunachal pradesh| 15
Puducherry       | 14
Goa              | 14
Manipur          | 12
Nagaland         | 11
Tripura          | 8
Sikkim           | 6
Mizoram          | 5
Andaman          | 3
Dadra            | 1
```

**7.4 Relationship Between Stream and AI Tool Preference**

```sql
SELECT Stream, Preferred_AI_Tool, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Stream, Preferred_AI_Tool
ORDER BY Stream, Count DESC;
```

*Result:*

```
stream           | preferred_ai_tool | count
-----------------|-------------------|------
Agriculture      | ChatGPT           | 61
Agriculture      | Copilot           | 60
Agriculture      | Gemini            | 58
Agriculture      | Other             | 52
Agriculture      | Bard              | 16
Agriculture      | Claude            | 14
Arts             | Gemini            | 123
Arts             | Copilot           | 99
Arts             | ChatGPT           | 81
Arts             | Other             | 66
Arts             | Claude            | 20
Arts             | Bard              | 18
Commerce         | ChatGPT           | 96
Commerce         | Copilot           | 85
Commerce         | Other             | 78
Commerce         | Gemini            | 60
Commerce         | Claude            | 27
Commerce         | Bard              | 18
Engineering      | Gemini            | 150
Engineering      | Copilot           | 104
Engineering      | ChatGPT           | 82
Engineering      | Other             | 81
Engineering      | Bard              | 21
Engineering      | Claude            | 16
Hotel-management | Copilot           | 81
Hotel-management | ChatGPT           | 74
Hotel-management | Gemini            | 72
Hotel-management | Other             | 66
Hotel-management | Claude            | 13
Hotel-management | Bard              | 8
Law              | Other             | 63
Law              | ChatGPT           | 59
Law              | Copilot           | 55
Law              | Gemini            | 44
Law              | Claude            | 13
Law              | Bard              | 11
Management       | ChatGPT           | 99
Management       | Copilot           | 91
Management       | Gemini            | 73
Management       | Other             | 73
Management       | Claude            | 20
Management       | Bard              | 14
Medical          | Copilot           | 70
Medical          | Other             | 67
Medical          | Gemini            | 63
Medical          | ChatGPT           | 61
Medical          | Bard              | 12
Medical          | Claude            | 7
Pharmacy         | Gemini            | 71
Pharmacy         | Other             | 56
Pharmacy         | Copilot           | 48
Pharmacy         | ChatGPT           | 48
Pharmacy         | Bard              | 14
Pharmacy         | Claude            | 12
Science          | ChatGPT           | 163
Science          | Other             | 121
Science          | Copilot           | 114
Science          | Gemini            | 111
Science          | Bard              | 19
Science          | Claude            | 15
```

-----

## Key Findings

### Overall Student Population and Distribution

  * The dataset comprises **3487 unique student records** after preprocessing and duplicate removal.
  * Student distribution across the years of study is relatively balanced:
      * **Year 1:** 874 students
      * **Year 2:** 931 students
      * **Year 3:** 843 students
      * **Year 4:** 839 students

### AI Tool Usage Patterns

  * **Average Daily Usage:** Students utilize AI tools for an average of **2.6 hours per day**.
  * **Top Preferred AI Tools:** **Gemini**, **ChatGPT**, and **Copilot** are the most favored AI tools among students, showing very similar preference counts.
      * Gemini: 825 preferences
      * ChatGPT: 824 preferences
      * Copilot: 807 preferences
  * **Colleges with Highest Adoption:**
      * National Institute of Technology: 175 active users
      * Indian Institute of Technology: 129 active users
      * Indian Institute of Information Technology: 59 active users
  * **Geographical Adoption:** A significant portion of responses (1515 records) did not specify a state, indicating a potential data entry issue or a large, unclassified group. Among specified states, **Maharashtra** (106 students), **Uttar Pradesh** (94 students), and **Rajasthan** (93 students) show the highest reported AI tool adoption.
  * **Usage by Academic Stream:** While the overall average usage is 2.6 hours, streams like Pharmacy, Arts, Law, Commerce, and Science show slightly higher average daily usage (2.7 hours), whereas Engineering and Hotel Management show slightly lower averages (2.3-2.4 hours).
  * **Usage by Year of Study:** Daily AI usage remains relatively consistent across all years of study, averaging between 2.5 and 2.6 hours, suggesting a stable integration of AI regardless of academic progression.

### Perceptions and Impact of AI Tools

  * **Overall Trust in AI Tools:** Student trust in AI tools is distributed across the scale (1-5, likely 5 being highest trust), with notable concentrations in the middle and lower-middle ranges.
      * Rating 5: 770 students
      * Rating 2: 718 students
      * Rating 1: 681 students
      * Rating 3: 668 students
      * Rating 4: 650 students
        This suggests a mixed but leaning towards cautious trust, with a significant portion expressing lower trust (ratings 1 and 2).
  * **Trust by Academic Stream:** Trust levels vary by stream, but no single trust level (e.g., "highly trust") consistently dominates across all streams. Many streams show a spread of trust levels, indicating diverse opinions within academic disciplines. For instance, 'Science' and 'Management' streams have a higher count for "5" (highest trust), while 'Arts' and 'Commerce' show a stronger presence in lower trust categories (1 and 2).
  * **Awareness Level vs. Usage Hours:** There isn't a strong linear correlation between awareness level (1-10) and average daily usage hours. While some awareness levels (e.g., 4 with 2.9 hours) show slightly higher usage, others (e.g., 2 and 3 with 2.4 hours) show slightly lower, and many are clustered around the overall average of 2.6 hours. This suggests that simply being "aware" doesn't directly translate to significantly higher or lower daily usage.

### Faculty & Institutional Attitude

  * **Professors' Allowance of AI Tools:** A notable divide exists regarding faculty stance on AI tool usage, with a slight majority of students reporting that their professors **do not allow** AI usage (1817 students) compared to those who report they **do allow** it (1670 students). This indicates a varied or unclear institutional policy landscape.

### Tech Access & Environment

  * **Most Common Device:** **Laptops** are the most frequently used devices for accessing AI tools (1286 students), followed by **tablets** (1130 students) and **mobile phones** (1071 students), suggesting a preference for devices that offer more robust interaction with AI applications.
  * **Internet Access Impact:** Internet access quality (High, Medium, Poor) does not appear to significantly impact average daily AI usage hours, as all categories show very similar average usage times (around 2.5-2.6 hours). This implies that students are able to maintain consistent AI usage regardless of perceived internet quality.

### Willingness to Pay & Tool Preference

  * **Overall Willingness to Pay:** Student willingness to pay for AI access is almost evenly split, with **1734 students willing to pay** and **1753 not willing**. This suggests a strong potential market balanced by a significant portion expecting free access.
  * **Preferred Tools for Paying Users:** Among students willing to pay, **Copilot** emerges as the most preferred tool (410 users), closely followed by **Gemini** (399 users) and **ChatGPT** (399 users). This indicates a strong market for these tools if offered as premium services.
  * **States with Highest Willingness to Pay:** Similar to overall adoption, a large number of responses for "willingness to pay" had no specified state (729 records). Among classified states, **Maharashtra** (57 students), **Rajasthan** (51 students), and **Uttar Pradesh** (48 students) show the highest reported willingness to pay for AI access.
  * **Stream vs. Preferred AI Tool:**
      * **Engineering, Arts, and Pharmacy** students show a strong preference for **Gemini**.
      * **Commerce and Science** students lean towards **ChatGPT**.
      * **Hotel Management and Medical** students tend to prefer **Copilot**.
      * The "Other" category consistently represents a significant portion of preferences across several streams, especially in Law and Science, indicating diverse tool usage beyond the major platforms.

-----

## Conclusion

This analysis of student AI usage in higher education reveals a landscape where AI tools are significantly integrated into academic life. Students are consistently using AI for an average of 2.6 hours daily across all years of study, primarily preferring Gemini, ChatGPT, and Copilot. While adoption is high in certain colleges and states, a notable portion of geographical data remains unspecified, indicating potential reporting gaps.

Student trust in AI tools is varied, leaning towards cautious optimism, and does not strongly correlate with usage hours. A key finding is the almost even split in faculty's allowance of AI tools, highlighting a need for clearer institutional policies. Laptops are the dominant access device, and internet access quality appears to have minimal impact on daily usage. Interestingly, student willingness to pay for AI access is nearly balanced, with specific tools like Copilot, Gemini, and ChatGPT being most favored by those willing to invest. Preferences for AI tools also show distinct patterns across different academic streams.

Overall, the data underscores AI's growing role in education, alongside diverse student perceptions and varied institutional responses.

-----

## Recommendations

Based on the insights gathered from this analysis, the following recommendations are proposed for various stakeholders:

### For Educational Institutions:

  * **Develop Clear AI Policies:** Given the nearly even split in professor allowance, colleges should establish clear, consistent guidelines for AI tool usage, promoting ethical and responsible integration into academic work.
  * **Integrate AI Literacy:** Offer workshops, courses, or modules on AI literacy to enhance student awareness, critical evaluation skills, and effective use of AI tools across all streams.
  * **Support & Resources:** Provide access to, or guidance on, preferred AI tools and ensure adequate technological infrastructure (like device accessibility) is in place, even if internet quality isn't a direct barrier to usage.

### For AI Tool Developers:

  * **Targeted Features:** Understand the varying tool preferences across academic streams to develop or highlight features most relevant to specific disciplines (e.g., specialized tools for Engineering vs. Arts).
  * **Flexible Monetization Models:** Consider freemium models or student-friendly subscription plans, as a substantial portion of students are willing to pay, but a near-equal number are not.
  * **Build Trust:** Address student concerns regarding trust by focusing on transparency, accuracy, and ethical AI development, potentially through educational content within the tools themselves.

### For Students:

  * **Promote Responsible Use:** Encourage peer-to-peer discussions and best practices for ethical AI integration into studies, emphasizing academic integrity.
  * **Explore Diverse Tools:** While certain tools are highly preferred, exploring a wider range of AI applications can cater to specific academic needs and enhance learning outcomes.
----
