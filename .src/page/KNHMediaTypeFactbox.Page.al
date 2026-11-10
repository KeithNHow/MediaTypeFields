namespace KNHMediaType;

page 53901 "KNH Media Type Factbox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "KNH Media Type";
    layout
    {
        area(Content)
        {
            field(Media; Rec.Media)
            {
                ToolTip = 'Specifies the value of the Media field.', Comment = '%';
            }
            field(MediaSet; Rec.MediaSet)
            {
                ToolTip = 'Specifies the value of the MediaSet field.', Comment = '%';
            }
        }
    }
}