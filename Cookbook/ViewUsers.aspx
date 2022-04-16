<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewUsers.aspx.cs" Inherits="Cookbook.ViewUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-12">
            <h2>Registered User Accounts</h2>

            <asp:Panel ID="pnlDisplayUsers" runat="server">
                <asp:GridView ID="gvDisplayUsers" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False" DataKeyNames="user_uid" OnRowCommand="gvDisplayUsers_RowCommand" OnRowDataBound="gvDisplayUsers_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="user_uid" HeaderText="User UUID" />
		                <asp:BoundField DataField="username" HeaderText="Username" />
                        <asp:BoundField DataField="email" HeaderText="Email" />
                        <asp:BoundField DataField="date_reg" HeaderText="Date Registered" />
                        <asp:TemplateField HeaderText="" >
                            <ItemTemplate>
                                <asp:Button ID="btnMod" runat="server" CssClass="btn btn-info" Text="Give Admin" OnClientClick="return confirm('Are you sure you want to mod this user?');" CommandName="GiveAdmin" Visible="false"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Delete User">
                            <ItemTemplate>
                                <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this user?');" CommandName="ReqUserDel" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
