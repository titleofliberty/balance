unit balanceframe;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls, StdCtrls;

type

  { TfraBalance }

  TfraBalance = class(TFrame)
    lblValue: TLabel;
    lblTitle: TLabel;
  private
    FValueColor: TColor;
    function GetTitle: string;
    function GetValue: string;
    procedure SetTitle(AValue: string);
    procedure SetValue(AValue: string);
    procedure SetValueColor(AValue: TColor);
  public
    property Title: string read GetTitle write SetTitle;
    property Value: string read GetValue write SetValue;
    property ValueColor: TColor read FValueColor write SetValueColor;
  end;

implementation

{$R *.lfm}

{ TfraBalance }

procedure TfraBalance.SetValueColor(AValue: TColor);
begin
  if FValueColor = AValue then Exit;
  FValueColor := AValue;
  lblValue.Font.Color := AValue;
end;

function TfraBalance.GetTitle: string;
begin
  result := lblTitle.Caption;
end;

function TfraBalance.GetValue: string;
begin
  result := lblValue.Caption;
end;

procedure TfraBalance.SetTitle(AValue: string);
begin
  lblTitle.Caption := AValue;
end;

procedure TfraBalance.SetValue(AValue: string);
begin
  lblValue.Caption := AValue;
end;

end.

