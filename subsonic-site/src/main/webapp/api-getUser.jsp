<a name="getUser"></a>
<section class="box">
    <h3>getUser</h3>

    <p>
        <code>http://your-server/rest/getUser.view</code>
        Since <a href="#versions">1.3.0</a>
    </p>

    <p>
        Get details about a given user, including which authorization roles and folder access it has.
        Can be used to enable/disable certain features in the client, such as jukebox control.
    </p>
    <table>
        <tr>
            <th>Parameter</th>
            <th>Required</th>
            <th>Default</th>
            <th>Comment</th>
        </tr>
        <tr>
            <td><code>username</code></td>
            <td>Yes</td>
            <td></td>
            <td>The name of the user to retrieve. You can only retrieve your own user unless you have admin
                privileges.
            </td>
        </tr>
    </table>
    <p>
        Returns a <code>&lt;subsonic-response&gt;</code> element with a nested <code>&lt;user&gt;</code>
        element on success. <a href="inc/api/examples/user_example_1.xml">Example</a>.
    </p>
</section>