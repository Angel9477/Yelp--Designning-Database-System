-- 1)Which types of businesses are most frequently 
-- reviewed by users with a high review count (>600), 
-- what are their average star ratings?

SELECT B.categories, AVG(R.stars) AS average_star_rating
FROM User U
INNER JOIN Review R ON U.User_id = R.User_id
INNER JOIN yelp_academic_dataset_business B ON R.Business_id = B.Business_id
WHERE U.Review_count > 600
GROUP BY B.categories
ORDER BY average_star_rating DESC;

-- 2) Who are the elite users? How many reviews do they have? 

SELECT u.user_id, u.name, u.review_count, date_joined.joined as joined, u.useful, u.funny,	u.cool, u.fans, round(avg(stars),1) as avg_stars
FROM user u
	INNER JOIN (
SELECT user_id, str_to_date(yelping_since, '%m/%d/%Y') as joined 
FROM user
		WHERE elite <> ""
                ) as date_joined 
ON u.user_id = date_joined.user_id
	INNER JOIN review r ON u.user_id = r.user_id
GROUP BY u.user_id, u.name, u.review_count, date_joined.joined, u.useful, u.funny, u.cool, u.fans
ORDER BY review_count desc;


-- 3) What are the top three businesses that have 
-- received the most reviews from users with a large 
-- fan base(>=100) on the platform?

SELECT b.business_id, b.name as business_name, count(*) as Amount_Of_Popular_Users, sum(b.review_count) as Total_Review
FROM user as u
RIGHT JOIN review r ON u.user_id = r.user_id
JOIN business b ON b.business_id = r.business_id
WHERE fans >= 100
GROUP BY b.business_id, b.name
ORDER BY Total_Review DESC
LIMIT 3;


-- 4-1)What’s the top 5 check-in business? 

SELECT * FROM project.business_checkin_plz;
select name,avg(review_count) as avg_review, 
avg(stars) as avg_stars ,categories, sum(date_count) as sum_checkin
from business_checkin_plz
group by business_id
order by sum_checkin desc 
limit 5;

-- 4-2)What business locations have the highest check-in frequency?
select postal_code, sum(date_count) as sum_checkin
from business_checkin_plz
group by postal_code
order by sum_checkin desc 
limit 5;

-- 4-3)What kind of business category are the top 5 check-in? 
select categories,sum(date_count) as sum_checkin
from business_checkin_plz
group by categories
order by sum_checkin desc 
limit 5;

-- 5) What kind of business category are the top 5 check-in?
SELECT categories,sum(date_count) as sum_checkin
FROM business b
INNER JOIN checkin c
GROUP BY categories
ORDER BY sum_checkin desc
LIMIT 5;

-- 6)Do businesses with higher review counts tend to  receive more tips?
SELECT name, review_count, tips_count
FROM business_data 
JOIN tips_data
ON business_data.business_id = tips_data.business_id
ORDER BY tips_count DESC;

