SELECT u.name, SUM(COALESCE(r.distance, 0)) as travelled_distance
FROM Users u
LEFT JOIN Rides r
ON u.id = r.user_id
GROUP BY u.id
ORDER BY SUM(r.distance) DESC, u.name