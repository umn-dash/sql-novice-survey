---
title: "Filtering"
teaching: 10
exercises: 10
questions:
- "How can I select subsets of data?"
objectives:
- "Write queries that select records that satisfy user-specified conditions."
- "Explain the order in which the clauses in a query are executed."
keypoints:
- "Use WHERE to specify conditions that records must meet in order to be included in a query's results."
- "Use AND, OR, and NOT to combine tests."
- "Filtering is done on whole records, so conditions can use fields that are not actually displayed."
- "Write queries incrementally."
---
One of the most powerful features of a database is
the ability to [filter]({{ page.root }}{% link reference.md %}#filter) data,
i.e.,
to select only those records that match certain criteria.
For example,
suppose we want to see when a particular site was visited.
We can select these records from the `Visit` table
by using a `WHERE` clause in our query:

~~~
SELECT * FROM Visit WHERE site_name = 'DR-1';
~~~
{: .sql}

|visit_id|site_name|visit_date|
|--------|---------|----------|
|619     |DR-1     |1927-02-08|
|622     |DR-1     |1927-02-10|
|844     |DR-1     |1932-03-22|

The database manager executes this query in two stages.
First,
it checks at each row in the `Visit` table
to see which ones satisfy the `WHERE`.
It then uses the column names following the `SELECT` keyword
to determine which columns to display.

This processing order means that
we can filter records using `WHERE`
based on values in columns that aren't then displayed:

~~~
SELECT visit_id FROM Visit WHERE site_name = 'DR-1';
~~~
{: .sql}

|visit_id|
|--------|
|619     |
|622     |
|844     |

![SQL Filtering in Action](../fig/sql-filter.svg)

We can use many other Boolean operators to filter our data.
For example,
we can ask for all information from the DR-1 site collected before 1930:

~~~
SELECT * FROM Visit WHERE site_name = 'DR-1' AND visit_date < '1930-01-01';
~~~
{: .sql}

|visit_id|site_name|visit_date|
|--------|---------|----------|
|619     |DR-1     |1927-02-08|
|622     |DR-1     |1927-02-10|

> ## Date Types
>
> Most database managers have a special data type for dates.
> In fact, many have two:
> one for dates,
> such as "May 31, 1971",
> and one for durations,
> such as "31 days".
> SQLite doesn't:
> instead,
> it stores dates as either text
> (in the ISO-8601 standard format "YYYY-MM-DD HH:MM:SS.SSSS"),
> real numbers
> ([Julian days](https://en.wikipedia.org/wiki/Julian_day), the number of days since November 24, 4714 BCE),
> or integers
> ([Unix time](https://en.wikipedia.org/wiki/Unix_time), the number of seconds since midnight, January 1, 1970).
> If this sounds complicated,
> it is,
> but not nearly as complicated as figuring out
> [historical dates in Sweden](https://en.wikipedia.org/wiki/Swedish_calendar).
{: .callout}

If we want to find out what measurements were taken by either Lake or Roerich,
we can combine the tests on their names using `OR`:

~~~
SELECT * FROM Measurement WHERE person_id = 'lake' OR person_id = 'roe';
~~~
{: .sql}

|visit_id|person_id|type|value|
|--------|---------|----|-----|
|734     |lake     |sal |0.05 |
|751     |lake     |sal |0.1  |
|752     |lake     |rad |2.19 |
|752     |lake     |sal |0.09 |
|752     |lake     |temp|-16.0|
|752     |roe      |sal |41.6 |
|837     |lake     |rad |1.46 |
|837     |lake     |sal |0.21 |
|837     |roe      |sal |22.5 |
|844     |roe      |rad |11.25|

Alternatively,
we can use `IN` to see if a value is in a specific set:

~~~
SELECT * FROM Measurement WHERE person_id IN ('lake', 'roe');
~~~
{: .sql}

|visit_id|person_id|type|value|
|--------|---------|----|-----|
|734     |lake     |sal |0.05 |
|751     |lake     |sal |0.1  |
|752     |lake     |rad |2.19 |
|752     |lake     |sal |0.09 |
|752     |lake     |temp|-16.0|
|752     |roe      |sal |41.6 |
|837     |lake     |rad |1.46 |
|837     |lake     |sal |0.21 |
|837     |roe      |sal |22.5 |
|844     |roe      |rad |11.25|

We can combine `AND` with `OR`,
but we need to be careful about which operator is executed first.
If we *don't* use parentheses,
we get this:

~~~
SELECT * FROM Measurement WHERE type = 'sal' AND person_id = 'lake' OR person_id = 'roe';
~~~
{: .sql}

|visit_id|person_id|type|value|
|--------|---------|----|-----|
|734     |lake     |sal |0.05 |
|751     |lake     |sal |0.1  |
|752     |lake     |sal |0.09 |
|752     |roe      |sal |41.6 |
|837     |lake     |sal |0.21 |
|837     |roe      |sal |22.5 |
|844     |roe      |rad |11.25|

which is salinity measurements by Lake,
and *any* measurement by Roerich.
We probably want this instead:

~~~
SELECT * FROM Measurement WHERE type = 'sal' AND (person_id = 'lake' OR person_id = 'roe');
~~~
{: .sql}

|visit_id|person_id|type|value|
|--------|---------|----|-----|
|734     |lake     |sal |0.05 |
|751     |lake     |sal |0.1  |
|752     |lake     |sal |0.09 |
|752     |roe      |sal |41.6 |
|837     |lake     |sal |0.21 |
|837     |roe      |sal |22.5 |

We can also filter by partial matches.  For example, if we want to
know something just about the site names beginning with "DR" we can
use the `LIKE` keyword.  The percent symbol acts as a
[wildcard]({{ page.root }}{% link reference.md %}#wildcard), matching any characters in that
place.  It can be used at the beginning, middle, or end of the string:

~~~
SELECT * FROM Visit WHERE site_name LIKE 'DR%';
~~~
{: .sql}

|visit_id|site_name|visit_date|
|--------|---------|----------|
|619     |DR-1     |1927-02-08|
|622     |DR-1     |1927-02-10|
|734     |DR-3     |1930-01-07|
|735     |DR-3     |1930-01-12|
|751     |DR-3     |1930-02-26|
|752     |DR-3     |          |
|844     |DR-1     |1932-03-22|


Finally,
we can use `DISTINCT` with `WHERE`
to give a second level of filtering:

~~~
SELECT DISTINCT person_id, type FROM Measurement WHERE person_id = 'lake' OR person_id = 'roe';
~~~
{: .sql}

|person_id|type|
|---------|----|
|lake     |sal |
|lake     |rad |
|lake     |temp|
|roe      |sal |
|roe      |rad |

But remember:
`DISTINCT` is applied to the values displayed in the chosen columns,
not to the entire rows as they are being processed.

> ## Growing Queries
>
> What we have just done is how most people "grow" their SQL queries.
> We started with something simple that did part of what we wanted,
> then added more clauses one by one,
> testing their effects as we went.
> This is a good strategy --- in fact,
> for complex queries it's often the *only* strategy --- but
> it depends on quick turnaround,
> and on us recognizing the right answer when we get it.
>
> The best way to achieve a quick turnaround is often
> to put a subset of data in a temporary database
> and run our queries against that,
> or to fill a small database with synthesized records.
> For example,
> instead of trying our queries against an actual database of 20 million Australians,
> we could run it against a sample of ten thousand,
> or write a small program to generate ten thousand random (but plausible) records
> and use that.
{: .callout}

> ## Fix This Query
>
> Suppose we want to select all sites that lie within 48 degrees of the equator.
> Our first query is:
>
> ~~~
> SELECT * FROM Site WHERE (lat > -48) OR (lat < 48);
> ~~~
> {: .sql}
>
> Explain why this is wrong,
> and rewrite the query so that it is correct.
>
> > ## Solution
> >
> > Because we used `OR`, a site on the South Pole for example will still meet
> > the second criteria and thus be included. Instead, we want to restrict this
> > to sites that meet _both_ criteria:
> >
> > ~~~
> > SELECT * FROM Site WHERE (lat > -48) AND (lat < 48);
> > ~~~
> > {: .sql}
> {: .solution}
{: .challenge}

> ## Finding Outliers
>
> Normalized salinity readings are supposed to be between 0.0 and 1.0.
> Write a query that selects all records from `Measurement`
> with salinity values outside this range.
>
> > ## Solution
> >
> > ~~~
> > SELECT * FROM Measurement WHERE type = 'sal' AND ((value > 1.0) OR (value < 0.0));
> > ~~~
> > {: .sql}
> >
> > |visit_id |person_id |type |value |
> > |---------|----------|-----|------|
> > |752      |roe       |sal  |41.6  |
> > |837      |roe       |sal  |22.5  |
> {: .solution}
{: .challenge}

> ## Matching Patterns
>
> Which of these expressions are true?
>
> 1. `'a' LIKE 'a'`
> 2. `'a' LIKE '%a'`
> 3. `'beta' LIKE '%a'`
> 4. `'alpha' LIKE 'a%%'`
> 5. `'alpha' LIKE 'a%p%'`
>
> > ## Solution
> >
> > 1. True because these are the same character.
> > 2. True because the wildcard can match _zero_ or more characters.
> > 3. True because the `%` matches `bet` and the `a` matches the `a`.
> > 4. True because the first wildcard matches `lpha` and the second wildcard matches zero characters (or vice versa).
> > 5. True because the first wildcard matches `l` and the second wildcard matches `ha`.
> {: .solution}
{: .challenge}
