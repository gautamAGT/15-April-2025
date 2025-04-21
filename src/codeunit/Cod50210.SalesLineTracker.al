codeunit 50210 "SalesLineTracker"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        NewCommentLine: Record "Sales Line";
    begin
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;

        if not GLAccount.Get(Rec."No.") then
            exit;


        if GLAccount."CommentNew" <> '' then begin
            NewCommentLine.Init();
            NewCommentLine."Document Type" := Rec."Document Type";
            NewCommentLine."Document No." := Rec."Document No.";
            NewCommentLine."Line No." := Rec."Line No." + 10000;
            NewCommentLine.Type := NewCommentLine.Type::Comment;
            NewCommentLine.Description := GLAccount."CommentNew";
            NewCommentLine.Insert(true);
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesLine(var Rec: Record "Sales Line")
    var
        CommentLine: Record "Sales Line";
        GLAccount: Record "G/L Account";
        NewCommentLine: Record "Sales Line";
    begin
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;

        if not GLAccount.Get(Rec."No.") then
            exit;

        CommentLine.Reset();
        CommentLine.SetRange("Document Type", Rec."Document Type");
        CommentLine.SetRange("Document No.", Rec."Document No.");
        CommentLine.SetRange("Line No.", Rec."Line No." + 10000);
        CommentLine.SetRange(Type, CommentLine.Type::Comment);


        if CommentLine.FindFirst() then begin

            if GLAccount."CommentNew" = '' then begin
                CommentLine.Delete();
            end else begin

                if CommentLine.Description <> GLAccount."CommentNew" then begin
                    CommentLine.Description := GLAccount."CommentNew";
                    CommentLine.Modify(true);
                end;
            end;
        end else begin

            if GLAccount."CommentNew" <> '' then begin
                NewCommentLine.Init();
                NewCommentLine."Document Type" := Rec."Document Type";
                NewCommentLine."Document No." := Rec."Document No.";
                NewCommentLine."Line No." := Rec."Line No." + 10000;
                NewCommentLine.Type := NewCommentLine.Type::Comment;
                NewCommentLine.Description := GLAccount."CommentNew";
                NewCommentLine.Insert(true);
            end;
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesLine(var Rec: Record "Sales Line")
    var
        CommentLine: Record "Sales Line";
    begin
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit;

        if CommentLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No." + 10000) then begin
            if CommentLine.Type = CommentLine.Type::Comment then
                CommentLine.Delete();
        end;
    end;
}
