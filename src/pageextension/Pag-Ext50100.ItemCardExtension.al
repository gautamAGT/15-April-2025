pageextension 50100 ItemCardExtension extends "G/L Account Card"
{
    layout
    {
        addafter(Totaling)
        {
            field(CommentNew; Rec.CommentNew)
            {
                ApplicationArea = All;
            }
        }
    }


}
