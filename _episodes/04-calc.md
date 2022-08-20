---
title: "Calculating New Values"
teaching: 5
exercises: 5
questions:
- "How can I calculate new values on the fly?"
objectives:
- "Write queries that calculate new values for each selected record."
keypoints:
- "Queries can do the usual arithmetic operations on values."
- "Use UNION to combine the results of two or more queries."
---
After carefully re-reading the expedition logs,
we realize that the radiation measurements they report
may need to be corrected upward by 5%.
Rather than modifying the stored data,
we can do this calculation on the fly
as part of our query:

~~~
SELECT 1.05 * value FROM Measurement WHERE type = 'rad';
~~~
{: .sql}

|1.05 * value  |
|--------------|
|10.311        |
|8.19          |
|8.8305        |
|7.581         |
|4.5675        |
|2.2995        |
|1.533         |
|11.8125       |

When we run the query,
the expression `1.05 * value` is evaluated for each row.
Expressions can use any of the fields,
all of usual arithmetic operators,
and a variety of common functions.
(Exactly which ones depends on which database manager is being used.)
For example,
we can convert temperature readings from Fahrenheit to Celsius
and round to two decimal places:

~~~
SELECT visit_id, round(5 * (value - 32) / 9, 2) FROM Measurement WHERE type = 'temp';
~~~
{: .sql}

|visit_id|round(5 * (value - 32) / 9, 2)|
|--------|------------------------------|
|734     |-29.72                        |
|735     |-32.22                        |
|751     |-28.06                        |
|752     |-26.67                        |

As you can see from this example, though, the string describing our
new field (generated from the equation) can become quite unwieldy. SQL
allows us to rename our fields, any field for that matter, whether it
was calculated or one of the existing fields in our database, for
succinctness and clarity. For example, we could write the previous
query as:

~~~
SELECT visit_id, round(5 * (value - 32) / 9, 2) as Celsius FROM Measurement WHERE type = 'temp';
~~~
{: .sql}

|visit_id|Celsius|
|--------|-------|
|734     |-29.72 |
|735     |-32.22 |
|751     |-28.06 |
|752     |-26.67 |

We can also combine values from different fields,
for example by using the string concatenation operator `||`:

~~~
SELECT personal_name || ' ' || family_name FROM Person;
~~~
{: .sql}

|personal_name \|\| ' ' \|\| family_name|
|---------------------------------------|
|William Dyer                           |
|Frank Pabodie                          |
|Anderson Lake                          |
|Valentina Roerich                      |
|Frank Danforth                         |

> ## Fixing Salinity Readings
>
> After further reading,
> we realize that Valentina Roerich
> was reporting salinity as percentages.
> Write a query that returns all of her salinity measurements
> from the `Measurement` table
> with the values divided by 100.
>
> > ## Solution
> >
> > ~~~
> > SELECT visit_id, value / 100 FROM Measurement WHERE person_id = 'roe' AND type = 'sal';
> > ~~~
> > {: .sql}
> >
> > |visit_id  |value / 100|
> > |----------|-----------|
> > |752       |0.416      |
> > |837       |0.225      |
> {: .solution}
{: .challenge}

> ## Unions
>
> The `UNION` operator combines the results of two queries:
>
> ~~~
> SELECT * FROM Person WHERE person_id = 'dyer' UNION SELECT * FROM Person WHERE person_id = 'roe';
> ~~~
> {: .sql}
>
> |person_id|personal_name|family_name |
> |---------|-------------|------------|
> |dyer     |William      |Dyer        |
> |roe      |Valentina    |Roerich     |
>
> The `UNION ALL` command is equivalent to the `UNION` operator,
> except that `UNION ALL` will select all values.
> The difference is that `UNION ALL` will not eliminate duplicate rows.
> Instead, `UNION ALL` pulls all rows from the query
> specifics and combines them into a table.
> The `UNION` command does a `SELECT DISTINCT` on the results set.
> If all the records to be returned are unique from your union,
> use `UNION ALL` instead, it gives faster results since it skips the `DISTINCT` step.
> For this section, we shall use UNION.
>
> Use `UNION` to create a consolidated list of salinity measurements
> in which Valentina Roerich's, and only Valentina's,
> have been corrected as described in the previous challenge.
> The output should be something like:
>
> |visit_id|value|
> |--------|-----|
> |619     |0.13 |
> |622     |0.09 |
> |734     |0.05 |
> |751     |0.1  |
> |752     |0.09 |
> |752     |0.416|
> |837     |0.21 |
> |837     |0.225|
>
> > ## Solution
> >
> > ~~~
> > SELECT visit_id, value FROM Measurement WHERE person_id != 'roe' AND type = 'sal' UNION SELECT visit_id, value / 100 FROM Measurement WHERE person_id = 'roe' AND type = 'sal' ORDER BY visit_id ASC;
> > ~~~
> > {: .sql}
> {: .solution}
{: .challenge}

> ## Selecting Major Site Identifiers
>
> The site identifiers in the `Visit` table have two parts
> separated by a '-':
>
> ~~~
> SELECT DISTINCT site FROM Visit;
> ~~~
> {: .sql}
>
> |site_name|
> |---------|
> |DR-1     |
> |DR-3     |
> |MSK-4    |
>
> Some major site identifiers (i.e. the letter codes) are two letters long and some are three.
> The "in string" function `instr(X, Y)`
> returns the 1-based index of the first occurrence of string Y in string X,
> or 0 if Y does not exist in X.
> The substring function `substr(X, I, [L])`
> returns the substring of X starting at index I, with an optional length L.
> Use these two functions to produce a list of unique major site identifiers.
> (For this data,
> the list should contain only "DR" and "MSK").
>
> > ## Solution
> > ```
> > SELECT DISTINCT substr(site_name, 1, instr(site_name, '-') - 1) AS MajorSite FROM Visit;
> > ```
> > {: .sql}
> {: .solution}
{: .challenge}
