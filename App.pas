unit App;

interface

uses XMLIntf, Classes, Dialogs;

type
  TApp = class
  private
  public
    Name, url, downloadUrl, image, description, version, author, plat, size,
      maindir: string;
    files: TStringList;
    BeforeCommands, AfterCommands, Commands: TList;
    constructor Create(node: IXMLNode);
    destructor Destroy; override;
  end;

implementation

uses Command;

constructor TApp.Create(node: IXMLNode);
var
  i: integer;
  node2: IXMLNode;
begin
  files := TStringList.Create;
  BeforeCommands := TList.Create;
  AfterCommands := TList.Create;
  Commands := TList.Create;

  for i := 0 to node.ChildNodes.Count - 1 do
  begin
    Name := node.ChildNodes.Nodes['Name'].Text;
    url := node.ChildNodes.Nodes['Url'].Text;
    downloadUrl := node.ChildNodes.Nodes['DownloadUrl'].Text;
    version := node.ChildNodes.Nodes['Version'].Text;
    author := node.ChildNodes.Nodes['Author'].Text;
    size := node.ChildNodes.Nodes['Size'].Text;
    description := node.ChildNodes.Nodes['Description'].Text;
    image := node.ChildNodes.Nodes['Image'].Text;
    plat := node.ChildNodes.Nodes['Platform'].Text;
  end;
  node2 := node.ChildNodes.Nodes['FilesList'];
  for i := 0 to node2.ChildNodes.Count - 1 do
  begin
    files.Add(node2.ChildNodes.Get(i).Text);
  end;
  node2 := node.ChildNodes.Nodes['CommandsList'].ChildNodes.Nodes
    ['BeforeInstallation'];
  for i := 0 to node2.ChildNodes.Count - 1 do
  begin
    BeforeCommands.Add(TCommand.Create(node2.ChildNodes.Get(i)));
  end;
  node2 := node.ChildNodes.Nodes['CommandsList'].ChildNodes.Nodes
    ['AfterInstallation'];
  for i := 0 to node2.ChildNodes.Count - 1 do
  begin
    AfterCommands.Add(TCommand.Create(node2.ChildNodes.Get(i)));
  end;
  node2 := node.ChildNodes.Nodes['CommandsList'].ChildNodes.Nodes
    ['Installation'];
  for i := 0 to node2.ChildNodes.Count - 1 do
  begin
    Commands.Add(TCommand.Create(node2.ChildNodes.Get(i)));
  end;
end;

destructor TApp.Destroy;
begin
  files.Destroy;
  BeforeCommands.Free;
  AfterCommands.Free;
  Commands.Free;
end;

end.
