-- Create the table to hold the student AI usage data
CREATE TABLE StudentAIUsage (
    Student_Name VARCHAR(255),
    College_Name VARCHAR(255),
    Stream VARCHAR(255),
    Year_of_Study INTEGER,
    AI_Tools_Used TEXT, -- Storing comma-separated list as TEXT
    Daily_Usage_Hours REAL,
    Use_Cases TEXT,     -- Storing comma-separated list as TEXT
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

SELECT * FROM StudentAIUsage LIMIT 5;
SELECT COUNT(*) FROM StudentAIUsage;

SELECT
    COUNT(*) FILTER (WHERE Student_Name IS NULL) AS null_student_name,
    COUNT(*) FILTER (WHERE College_Name IS NULL) AS null_college_name,
    COUNT(*) FILTER (WHERE Stream IS NULL) AS null_stream,
    COUNT(*) FILTER (WHERE Year_of_Study IS NULL) AS null_year_of_study,
    COUNT(*) FILTER (WHERE AI_Tools_Used IS NULL OR AI_Tools_Used = '') AS null_ai_tools_used, -- Also check for empty strings
    COUNT(*) FILTER (WHERE Daily_Usage_Hours IS NULL) AS null_daily_usage_hours,
    COUNT(*) FILTER (WHERE Use_Cases IS NULL OR Use_Cases = '') AS null_use_cases, -- Also check for empty strings
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

DELETE FROM StudentAIUsage
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT ctid,
               ROW_NUMBER() OVER (
                   PARTITION BY Student_Name, College_Name, Stream, Year_of_Study
                   ORDER BY Student_Name  -- You can modify this to control which row is kept
               ) AS rn
        FROM StudentAIUsage
    ) sub
    WHERE rn > 1
);

-- Data Exploration
-- Total Number of Students Record - 3487
SELECT COUNT(*) FROM StudentAIUsage;

-- Distribution of Students by Year of Study
SELECT year_of_study, COUNT(year_of_study) AS students_per_year
FROM StudentAIUsage
GROUP BY year_of_study;
-- There is the result
-- "year_of_study"	"students_per_year"
-- 		1				874
-- 		3				843
-- 		4				839
-- 		2				931

-- AI Tool Usage Patterns
-- Top 5 colleges in AI adoption
SELECT College_Name, COUNT(*) AS Active_Users
FROM StudentAIUsage
WHERE Daily_Usage_Hours > 0
GROUP BY College_Name
ORDER BY Active_Users DESC
LIMIT 5;
/*
"college_name"	"active_users"
"National Institute of Technology "	175
"Indian Institute of Technology "	129
"Indian Institute of Information Technology "	59
"Indian Institute of Management "	56
"Institute of Hotel Management "	19
*/

-- states have the highest AI tool adoption
SELECT 
	state,
	COUNT(*) AS Total_students
FROM StudentAIUsage
GROUP BY state
ORDER BY Total_students DESC;
/*
"state"	"total_students"
	1515
"Maharashtra"	106
"Uttar pradesh"	94
"Rajasthan"	93
"Punjab"	91
"Kerala"	88
"Andhra pradesh"	87
"Karnataka"	87
"Tamil nadu"	85
"Gujarat"	84
"Chhattisgarh"	81
"Assam"	79
"Madhya pradesh"	79
"West bengal"	79
"Haryana"	76
"Bihar"	75
"Uttarakhand"	71
"Delhi ncr"	68
"Telangana"	64
"Orissa"	59
"Jammu"	58
"Himachal pradesh"	56
"Jharkhand"	52
"Chandigarh"	41
"Arunachal pradesh"	35
"Meghalaya"	34
"Goa"	32
"Nagaland"	24
"Puducherry"	23
"Manipur"	19
"Tripura"	19
"Sikkim"	16
"Mizoram"	10
"Andaman"	5
"Dadra"	2
*/

-- Average Daily Usage Hours
SELECT ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS avg_daily_usage_hours
FROM StudentAIUsage;
-- Students use AI tools averagely daily for 2.6 hours

-- Top 5 Most Preferred AI Tools
SELECT 
	Preferred_AI_Tool, 
	COUNT(*) AS Preference_Count
FROM StudentAIUsage
GROUP BY Preferred_AI_Tool
ORDER BY Preference_Count DESC;
/*
"preferred_ai_tool"	"preference_count"
"Gemini"	825
"ChatGPT"	824
"Copilot"	807
"Other"	723
"Claude"	157
"Bard"	151
*/

-- Average Daily Usage Hours by Academic Stream
SELECT
	stream,
	ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS avg_daily_usage_hours
FROM StudentAIUsage
GROUP BY stream
ORDER BY avg_daily_usage_hours DESC;
/*
"stream"	"avg_daily_usage_hours"
"Pharmacy"	2.7
"Arts"	2.7
"Law"	2.7
"Commerce"	2.7
"Science"	2.7
"Agriculture"	2.6
"Management"	2.5
"Medical"	2.4
"Hotel-management"	2.4
"Engineering"	2.3
*/

-- average daily usage of AI tools by year of study 
SELECT 
	Year_of_Study,  
	ROUND(AVG(daily_usage_hours)::NUMERIC,1)AS Avg_Usage
FROM StudentAIUsage
GROUP BY Year_of_Study
ORDER BY Year_of_Study;
/*
"year_of_study"	"avg_usage"
1	2.5
2	2.6
3	2.6
4	2.6
*/


--  Perceptions and Impact of AI Tools
-- How Trust in AI Tools Varies by Stream
SELECT Stream, Trust_in_AI_Tools, COUNT(*) AS NumberOfStudents
FROM StudentAIUsage
GROUP BY Stream, Trust_in_AI_Tools
ORDER BY Stream, NumberOfStudents DESC;
/*
"stream"	"trust_in_ai_tools"	"numberofstudents"
"Agriculture"	"3"	57
"Agriculture"	"2"	55
"Agriculture"	"5"	54
"Agriculture"	"4"	53
"Agriculture"	"1"	42
"Arts"	"2"	95
"Arts"	"5"	95
"Arts"	"1"	79
"Arts"	"4"	72
"Arts"	"3"	66
"Commerce"	"1"	84
"Commerce"	"3"	79
"Commerce"	"5"	74
"Commerce"	"2"	68
"Commerce"	"4"	59
"Engineering"	"2"	125
"Engineering"	"3"	94
"Engineering"	"4"	85
"Engineering"	"5"	83
"Engineering"	"1"	67
"Hotel-management"	"3"	72
"Hotel-management"	"2"	66
"Hotel-management"	"4"	62
"Hotel-management"	"1"	61
"Hotel-management"	"5"	53
"Law"	"2"	59
"Law"	"5"	56
"Law"	"4"	49
"Law"	"3"	43
"Law"	"1"	38
"Management"	"5"	99
"Management"	"1"	94
"Management"	"4"	67
"Management"	"3"	56
"Management"	"2"	54
"Medical"	"3"	60
"Medical"	"4"	58
"Medical"	"1"	56
"Medical"	"5"	56
"Medical"	"2"	50
"Pharmacy"	"2"	64
"Pharmacy"	"5"	57
"Pharmacy"	"4"	52
"Pharmacy"	"3"	39
"Pharmacy"	"1"	37
"Science"	"5"	143
"Science"	"1"	123
"Science"	"3"	102
"Science"	"4"	93
"Science"	"2"	82
*/

-- student's trust in AI Tools
SELECT 
	Trust_in_AI_Tools, 
	COUNT(*) AS Trust_rating
FROM StudentAIUsage
GROUP BY Trust_in_AI_Tools
ORDER BY Trust_in_AI_Tools DESC;
/*
"trust_in_ai_tools"	"trust_rating"
"5"	770
"4"	650
"3"	668
"2"	718
"1"	681
*/

-- awareness level correlate with usage hours
SELECT Awareness_Level, ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS Avg_Usage
FROM StudentAIUsage
GROUP BY Awareness_Level
ORDER BY Awareness_Level;
/*
"awareness_level"	"avg_usage"
1	2.7
2	2.4
3	2.4
4	2.9
5	2.6
6	2.5
7	2.6
8	2.4
9	2.6
10	2.6
*/

-- Faculty & Institutional Attitude
-- colleges allow AI usage as per students
SELECT 
	Do_Professors_Allow_Use, 
	COUNT(*) AS Student_Count
FROM StudentAIUsage
GROUP BY Do_Professors_Allow_Use;
/*
"do_professors_allow_use"	"student_count"
"No"	1817
"Yes"	1670
*/

-- Tech Access & Environment
-- device most commonly used for accessing AI tools
SELECT Device_Used, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Device_Used
ORDER BY Count DESC;
/*
"device_used"	"count"
"Laptop"	1286
"Tablet"	1130
"Mobile"	1071
*/

--  internet access quality impact daily AI usage hours
SELECT Internet_Access, ROUND(AVG(daily_usage_hours)::NUMERIC,1) AS Avg_Usage
FROM StudentAIUsage
GROUP BY Internet_Access;
/*
"internet_access"	"avg_usage"
"High"	2.5
"Poor"	2.5
"Medium"	2.6
*/

-- Willingness to Pay & Tool Preference
-- Are students willing to pay for access to AI tools?
SELECT Willing_to_Pay_for_Access, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Willing_to_Pay_for_Access;
/*
"willing_to_pay_for_access"	"count"
"No"	1753
"Yes"	1734
*/

-- Which AI tools are most preferred among those willing to pay?
SELECT Preferred_AI_Tool, COUNT(*) AS Count
FROM StudentAIUsage
WHERE Willing_to_Pay_for_Access = 'Yes'
GROUP BY Preferred_AI_Tool
ORDER BY Count DESC;
/*
"preferred_ai_tool"	"count"
"Copilot"	410
"Gemini"	399
"ChatGPT"	399
"Other"	363
"Claude"	84
"Bard"	79
*/

-- Which states show highest willingness to pay for AI access?
SELECT State, COUNT(*) AS Willing_Count
FROM StudentAIUsage
WHERE Willing_to_Pay_for_Access = 'Yes'
GROUP BY State
ORDER BY Willing_Count DESC;
/*
"state"	"willing_count"
	729
"Maharashtra"	57
"Rajasthan"	51
"Uttar pradesh"	48
"Gujarat"	47
"Karnataka"	47
"Chhattisgarh"	44
"Assam"	44
"West bengal"	44
"Tamil nadu"	43
"Kerala"	41
"Madhya pradesh"	41
"Punjab"	40
"Bihar"	40
"Uttarakhand"	38
"Andhra pradesh"	37
"Delhi ncr"	35
"Jharkhand"	34
"Haryana"	33
"Jammu"	33
"Orissa"	32
"Telangana"	30
"Himachal pradesh"	24
"Chandigarh"	17
"Meghalaya"	16
"Arunachal pradesh"	15
"Puducherry"	14
"Goa"	14
"Manipur"	12
"Nagaland"	11
"Tripura"	8
"Sikkim"	6
"Mizoram"	5
"Andaman"	3
"Dadra"	1
*/

-- What is the relationship between stream and AI tool preference?
SELECT Stream, Preferred_AI_Tool, COUNT(*) AS Count
FROM StudentAIUsage
GROUP BY Stream, Preferred_AI_Tool
ORDER BY Stream, Count DESC;
/*
"stream"	"preferred_ai_tool"	"count"
"Agriculture"	"ChatGPT"	61
"Agriculture"	"Copilot"	60
"Agriculture"	"Gemini"	58
"Agriculture"	"Other"	52
"Agriculture"	"Bard"	16
"Agriculture"	"Claude"	14
"Arts"	"Gemini"	123
"Arts"	"Copilot"	99
"Arts"	"ChatGPT"	81
"Arts"	"Other"	66
"Arts"	"Claude"	20
"Arts"	"Bard"	18
"Commerce"	"ChatGPT"	96
"Commerce"	"Copilot"	85
"Commerce"	"Other"	78
"Commerce"	"Gemini"	60
"Commerce"	"Claude"	27
"Commerce"	"Bard"	18
"Engineering"	"Gemini"	150
"Engineering"	"Copilot"	104
"Engineering"	"ChatGPT"	82
"Engineering"	"Other"	81
"Engineering"	"Bard"	21
"Engineering"	"Claude"	16
"Hotel-management"	"Copilot"	81
"Hotel-management"	"ChatGPT"	74
"Hotel-management"	"Gemini"	72
"Hotel-management"	"Other"	66
"Hotel-management"	"Claude"	13
"Hotel-management"	"Bard"	8
"Law"	"Other"	63
"Law"	"ChatGPT"	59
"Law"	"Copilot"	55
"Law"	"Gemini"	44
"Law"	"Claude"	13
"Law"	"Bard"	11
"Management"	"ChatGPT"	99
"Management"	"Copilot"	91
"Management"	"Gemini"	73
"Management"	"Other"	73
"Management"	"Claude"	20
"Management"	"Bard"	14
"Medical"	"Copilot"	70
"Medical"	"Other"	67
"Medical"	"Gemini"	63
"Medical"	"ChatGPT"	61
"Medical"	"Bard"	12
"Medical"	"Claude"	7
"Pharmacy"	"Gemini"	71
"Pharmacy"	"Other"	56
"Pharmacy"	"Copilot"	48
"Pharmacy"	"ChatGPT"	48
"Pharmacy"	"Bard"	14
"Pharmacy"	"Claude"	12
"Science"	"ChatGPT"	163
"Science"	"Other"	121
"Science"	"Copilot"	114
"Science"	"Gemini"	111
"Science"	"Bard"	19
"Science"	"Claude"	15
*/


SELECT * FROM StudentAIUsage;