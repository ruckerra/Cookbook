<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountPage.aspx.cs" Inherits="Cookbook.AccountPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="Panel1" runat="server">
        <div class="row">
            <div class="col-sm-3" style="width:300px;height:300px">
                <div>
                    <asp:Label ID="user_img" runat="server" Text="user_avatar"></asp:Label>
                </div>
            </div>

            <div class="col-sm-9">
                <asp:Label ID="user_info" runat="server" style="display:block" Text="username"></asp:Label>
                <label for="fuUserImage" style="display:inline">Upload Image: </label>
                <asp:FileUpload ID="fuUserImage" style="margin-bottom:1rem" runat="server" ClientIDMode="Static" CssClass="form-control-file" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" style="display:block;margin-bottom:1rem" CssClass="btn btn-primary btn-block" OnClick="btnUpdate_Click"/>
                <asp:Button ID="btnSignOut" runat="server" style="display:block;margin-bottom:1rem" CssClass="btn btn-danger btn-block" Text="Sign Out" Visible="false" OnClick="btnSignOut_Click"/>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-9">
                <asp:Button ID="btnOp" CssClass="btn btn-warning btn-block" runat="server" Text="View Accounts" Visible="false" OnClick="btnOp_Click" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
