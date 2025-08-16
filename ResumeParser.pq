let
    // SOURCE OPTIONS
    // Option A: Import resume_sample.csv from /data (already connected via Get Data)
    // Option B: Paste your raw resume text here between triple quotes
    RawResumeText = "",
    // Load the skills dictionary
    Skills = Csv.Document(File.Contents("data/skills_dictionary.csv"),[Delimiter=",", Columns=2, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    SkillsPromoted = Table.PromoteHeaders(Skills, [PromoteAllScalars=true]),
    SkillsClean = Table.TransformColumns(SkillsPromoted,{{"skill", Text.Lower, type text}, {"priority", Int64.Type}}),
    // Load resume_sample.csv
    ResumeCsv = Csv.Document(File.Contents("data/resume_sample.csv"),[Delimiter=",", Columns=2, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    ResumePromoted = Table.PromoteHeaders(ResumeCsv, [PromoteAllScalars=true]),
    // Extract skills row
    SkillsRow = Table.SelectRows(ResumePromoted, each [section] = "Skills"),
    SkillsText = if Table.RowCount(SkillsRow) > 0 then Text.Lower(Text.From(SkillsRow{0}[content])) else "",
    // Split skills by ; or ,
    Split1 = List.Transform(Text.SplitAny(SkillsText, ";,"), each Text.Trim(_)),
    SkillsList = List.RemoveNulls(List.Select(Split1, each _ <> "")),
    // Turn to table of resume skills
    ResumeSkills = Table.FromList(SkillsList, Splitter.SplitByNothing(), {"skill"}, null, ExtraValues.Ignore),
    ResumeSkillsClean = Table.Distinct(ResumeSkills),
    ResumeSkillsWithPriority = Table.NestedJoin(ResumeSkillsClean, {"skill"}, SkillsClean, {"skill"}, "SkillDim", JoinKind.LeftOuter),
    Expanded = Table.ExpandTableColumn(ResumeSkillsWithPriority, "SkillDim", {"priority"}, {"priority"}),
    Filled = Table.ReplaceValue(Expanded, null, 1, Replacer.ReplaceValue, {"priority"})
in
    Filled
