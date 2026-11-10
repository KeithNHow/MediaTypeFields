namespace KNHMediaType;
using System.Environment;
using System.IO;
using System.Utilities;

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

    actions
    {
        area(Processing)
        {
            group(Import)
            {
                action(ImportMedia)
                {
                    ApplicationArea = All;
                    Caption = 'Import Media';
                    Image = Import;
                    ToolTip = 'Import media from a file.';

                    trigger OnAction()
                    var
                        FromFileName: Text;
                        InStreamPic: InStream;
                    begin
                        if UploadIntoStream(FromFileName, InStreamPic) then begin
                            Rec.Media.ImportStream(InStreamPic, FromFileName);
                            Rec.Modify(true)
                        end;
                    end;
                }
                action(ImportMediaSet)
                {
                    ApplicationArea = All;
                    Caption = 'Import MediaSet';
                    Image = Import;
                    ToolTip = 'Import media set from a file.';

                    trigger OnAction()
                    var
                        FromFileName: Text;
                        InStreamPic: InStream;
                    begin
                        if UploadIntoStream(FromFileName, InStreamPic) then begin
                            Rec.MediaSet.ImportStream(InStreamPic, FromFileName);
                            Rec.Modify(true)
                        end;
                    end;
                }
            }
            group(Export)
            {
                action(ExportMedia)
                {
                    ApplicationArea = All;
                    Caption = 'Export Media';
                    Image = Export;
                    ToolTip = 'Export media to a file.';

                    trigger OnAction()
                    var
                        TenantMedia: Record "Tenant Media";
                        InStreamPic: InStream;
                        ImageLbl: Label '%1_Image.jpg', Comment = '%1 Image file name format';
                        Filename: Text;
                    begin
                        if TenantMedia.Get(Rec.Media.MediaId) then begin
                            tenantMedia.CalcFields(Content);
                            if tenantmedia.Content.HasValue then begin
                                Filename := StrSubstNo(ImageLbl, Rec.TableCaption);
                                TenantMedia.Content.CreateInStream(InStreamPic);
                                DownloadFromStream(InStreamPic, '', '', '', Filename)
                            end
                        end
                    end;
                }
                action(ExportMediaSet)
                {
                    ApplicationArea = All;
                    Caption = 'Export MediaSet';
                    Image = Export;
                    ToolTip = 'Export media set to a file.';

                    trigger OnAction()
                    var
                        TenantMedia: Record "Tenant Media";
                        DataCompression: Codeunit "Data Compression";
                        TempBlob: Codeunit "Temp Blob";
                        InStreamPic: InStream;
                        i: Integer;
                        ImageLbl: Label '%1_Image_%2.zip', Comment = '%1 %2 Image Set file name format';
                        OutStream: OutStream;
                        Filename: Text;
                        ZipFileName: Text;
                    begin
                        ZipFileName := 'Images.zip';
                        DataCompression.CreateZipArchive();
                        for i := 1 to Rec.MediaSet.Count do
                            if TenantMedia.Get(Rec.MediaSet.item(i)) then begin
                                TenantMedia.CalcFields(Content);
                                if TenantMedia.Content.HasValue then begin
                                    Clear(InStreamPic);
                                    TenantMedia.Content.CreateInStream(InStreamPic);
                                    Filename := StrSubstNo(ImageLbl, Rec.TableCaption, i);
                                    DataCompression.AddEntry(InstreamPic, Filename);
                                end;
                            end;
                        TempBlob.CreateOutStream(OutStream);
                        DataCompression.SaveZipArchive(OutStream);
                        TempBlob.CreateInStream(InStreamPic);
                        DownloadFromStream(InStreamPic, '', '', '', ZipFileName);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Import_Promoted1; ImportMedia)
                {
                }
                actionref(Import_Promoted2; ImportMediaSet)
                {
                }
                actionref(Export_Promoted1; ExportMedia)
                {
                }
                actionref(Export_Promoted2; ExportMediaSet)
                {
                }
            }
        }
    }
}
