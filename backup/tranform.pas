unit tranform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Spin, GizmoCalendar;

type

  { TfrmTran }

  TfrmTran = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    FloatSpinEdit1: TFloatSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    txtDescription: TComboBox;
    GizmoCalendar1: TGizmoCalendar;
    Label1: TLabel;
    txtCategory: TComboBox;
  private

  public

  end;

var
  frmTran: TfrmTran;

implementation

{$R *.lfm}

end.

