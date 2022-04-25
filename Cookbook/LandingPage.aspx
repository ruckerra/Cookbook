<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="Cookbook.LandingPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Search Recipes</h2>
    <asp:Panel ID="pnlSearchRecipes" runat="server" ClientIDMode="Static">
        <div class ="row">
            <div class="col-md-2">
                <asp:Label for="txtRecipeName" runat="server">Recipe Name: </asp:Label>
                <asp:TextBox ID="txtRecipeName" runat="server" CssClass="form-control npt"></asp:TextBox>
                &nbsp; 
                <asp:Label for="dlRecipeType" runat="server">Recipe Type:</asp:Label> 
                <asp:DropDownList ID="dlRecipeType" runat="server" CssClass="form-select">
                    <asp:ListItem Selected="True" Value=""></asp:ListItem>
                    <asp:ListItem>Breakfast</asp:ListItem>
                    <asp:ListItem>Brunch</asp:ListItem>
                    <asp:ListItem>Lunch</asp:ListItem>
                    <asp:ListItem>Linner</asp:ListItem>
                    <asp:ListItem>Apetizer</asp:ListItem>
                    <asp:ListItem>Dinner</asp:ListItem>
                    <asp:ListItem>Dessert</asp:ListItem>
                    <asp:ListItem>Snack</asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlRecipeTypeConnection" runat="server" ConnectionString="<%$ ConnectionStrings:CookbookConnectionString %>" SelectCommand="SELECT DISTINCT [denomination] FROM [recipes]"></asp:SqlDataSource>
            </div>
            <div class="col-md-10">
            <asp:CheckBox ID="chkVegetarian" runat="server" Text="Vegetarian" CssClass="form-select-input" />
            <br />
            <asp:CheckBox ID="chkGlutenFree" runat="server" Text="Gluten Free" CssClass="form-select-input"/>
            <br />
            <asp:CheckBox ID="chkFavorites" runat="server" Text="Your Favorites" Visible="false" CssClass="form-select-input"/>
            </div>     
        </div>
        <br />
        <div class="row" style="margin-bottom:1rem">
            <div class="col-md-12">
                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary btn-frost btn-oline-primary" Height="34px" Text="Search" Width="81px" OnClick="btnSearch_Click" />
                <asp:Button ID="btnCancelSearch" runat="server" CssClass="btn btn-secondary btn-frost btn-oline-secondary" OnClick="btnCancelSearch_Click" Text="Cancel" />
            </div>
        </div>
    </asp:Panel>
    <asp:Panel CssClass="frost" ID="pnlRecipeList" runat="server">
        <asp:GridView ID="gvRecipeList" runat="server" CssClass="table tbl" AutoGenerateColumns="False" OnRowCommand="gvRecipeList_RowCommand" OnRowDataBound="gvRecipeList_RowDataBound" DataKeyNames="recipe_name">
            <Columns>
                <asp:BoundField DataField="recipe_name" HeaderText="Recipe Name" />
                <asp:BoundField DataField="denomination" HeaderText="Type" />
                <asp:BoundField DataField="total_time" HeaderText="Total Time" />
                <asp:BoundField DataField="vegetarian" HeaderText="Vegetarian" />
                <asp:BoundField DataField="gluten_free" HeaderText="Gluten Free" />
                <asp:TemplateField HeaderText="Save Recipe">
                    <ItemTemplate>
                        <asp:Button ID="btnFavRecipe" runat="server" Text="Favorite" CssClass="btn btn-primary btn-frost btn-oline-primary" CommandName="FavRecipe"/>
                        <asp:Button ID="btnViewRecipe" runat="server" Text =" View" CssClass="btn btn-info btn-frost btn-oline-info" CommandName="ViewRecipe" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

    </asp:Panel>
</asp:Content>
