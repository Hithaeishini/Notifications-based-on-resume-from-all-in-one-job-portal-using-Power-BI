let
    Sources = {
        Csv.Document(File.Contents("data/job_feeds/naukri.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
        Csv.Document(File.Contents("data/job_feeds/linkedin.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
        Csv.Document(File.Contents("data/job_feeds/indeed.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
        Csv.Document(File.Contents("data/job_feeds/shine.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
        Csv.Document(File.Contents("data/job_feeds/foundit.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
        Csv.Document(File.Contents("data/job_feeds/cutshort.csv"),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.Csv])
    },
    Promote = List.Transform(Sources, each Table.PromoteHeaders(_,[PromoteAllScalars=true])),
    Combined = Table.Combine(Promote),
    // Normalize columns
    ChangedTypes = Table.TransformColumnTypes(Combined,{
        {"experience_min", Int64.Type}, {"experience_max", Int64.Type}, {"salary_min", Int64.Type}, {"posted_date", type date}
    }),
    // Split required_skills to rows
    SplitSkills = Table.ExpandListColumn(Table.TransformColumns(ChangedTypes, {{"required_skills", each List.Transform(Text.SplitAny(Text.Lower(_),";,"), Text.Trim), type list}}), "required_skills")
in
    SplitSkills
