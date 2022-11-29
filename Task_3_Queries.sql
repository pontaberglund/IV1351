/*
Show the number of lessons given per month during a specified year. 
This query is expected to be performed a few times per week. 
It shall be possible to retrieve the total number of lessons per month (just one number per month)
and the specific number of individual lessons, group lessons and ensembles (three numbers per month). 
It's not required that all four numbers (total plus one per lesson type) for a particular month are on the same row;
 you're allowed to have one row for each number as long as it's clear to which month each number belongs. However,
it's most likely easier to understand the result if you do place all numbers for a particular month on the same row,
and it's an interesting exercise, therefore you're encouraged to try.
*/
SELECT COUNT(*), COUNT(*), COUNT(*) FROM instructor_availability AS ind, group_lesson AS gro, ensemble AS ens
INNER JOIN time_slot AS timg ON timg.time_slot_id=gro.time_slot_id INNER JOIN time_slot AS timen ON timen.time_slot_id=ens.time_slot_id
WHERE ind.date >= '2023-11-01' AND ind.date <= '2023-11-30' AND timg.date >= '2023-11-01' AND timg.date <= '2023-11-30'
AND timen.date >='2023-11-01' AND timen.date <='2023-11-30'; 

SELECT COUNT(*), COUNT(*), COUNT(*) FROM instructor_availability AS ind, group_lesson AS gro, ensemble AS ens
INNER JOIN time_slot AS timg ON timg.id=gro.time_slot_id INNER JOIN time_slot AS timen ON timen.id=ens.time_slot_id
WHERE ind.date >= '2023-11-01' AND ind.date <= '2023-11-30' AND timg.date >= '2023-11-01' AND timg.date <= '2023-11-30'
AND timen.date >='2023-11-01' AND timen.date <='2023-11-30'; 

