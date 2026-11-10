namespace KNHMediaType;

page 53900 "KNH Media Type"
{
    ApplicationArea = All;
    Caption = 'Media Type';
    PageType = Card;
    SourceTable = "KNH Media Type";
    usageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Media; Rec.Media)
                {
                    ToolTip = 'Specifies the value of the Media field.', Comment = '%';
                }
                field(MediaSet; Rec.MediaSet)
                {
                    ToolTip = 'Specifies the value of the MediaSet field.', Comment = '%';
                }
                field("Blob"; Rec."Blob")
                {
                    ToolTip = 'Specifies the value of the Blob field.', Comment = '%';
                }
            }
        }
        area(FactBoxes)
        {
            part(KNHMediaTypeFactBox; "KNH Media Type FactBox")
            {
                subpageLink = Code = field("Code");
            }
        }
    }
}
