<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UploadRecipe.aspx.cs" Inherits="Cookbook.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Upload a Recipe</h2>
    <asp:Panel ID="pnlUploadRecipe" runat="server">
        <div class="row">
            <div class="col-md-2">
                <label for="txtRecipeName">Recipe Name: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtRecipeName" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtPrepTime">Prep Time: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtPrepTime" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtTotalTime">Total Time: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtTotalTime" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="chkGlutenFree">Gluten Free: </label>
            </div>
            <div class="col-md-2">
                <asp:CheckBox ID="chkGlutenFree" runat="server" Text="Yes" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="chkVegetarian">Vegetarian: </label>
            </div>
            <div class="col-md-2">
                <asp:CheckBox ID="chkVegetarian" runat="server" Text="Yes" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="ddType">Type: </label>
            </div>
            <div class="col-md-10">
                <asp:DropDownList ID="ddType" runat="server">
                    <asp:ListItem>Breakfast</asp:ListItem>
                    <asp:ListItem>Lunch</asp:ListItem>
                    <asp:ListItem>Dinner</asp:ListItem>
                    <asp:ListItem>Dessert</asp:ListItem>
                    <asp:ListItem>Snack</asp:ListItem>
                    <asp:ListItem>Appetizer</asp:ListItem>
                    <asp:ListItem>Brunch</asp:ListItem>
                    <asp:ListItem>Linner</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtIngredients">Ingredients: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtIngredients" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtDirections">Directions: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtDirections" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtNotes">Notes: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtNotes" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class ="col-md-6">
                <asp:Button ID="btnSave" runat="server" Text="Save" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="False" />
            </div>
        </div>

    </asp:Panel>
    <asp:Panel ID="pnlViewRecentRecipes" runat="server">
        <asp:GridView ID="gvRecentRecipes" runat="server">
            <EmptyDataTemplate>
                <asp:Button ID="btnEdit" runat="server" CssClass="btn-primary" Text="Edit" />
                <asp:Button ID="btnDelete" runat="server" CssClass="btn-danger" Text="Delete" />
            </EmptyDataTemplate>
        </asp:GridView>
    </asp:Panel>

</asp:Content>
