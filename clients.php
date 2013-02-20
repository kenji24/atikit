<?php
require_once("classes/core.inc.php");

class clients extends core
{

	public function __construct()
	{
		parent::__construct();
		if (!$this->isProvidingCompany())		// Only accessible by provider
			$this->reloadTarget();

		$data = base::subHeader("Client List", "View/Create/List Clients");
		$data .= base::begin();
		$this->export($data);
	}

	public function main()
	{
		$this->listClients();

	}


	public function createClient()
	{
		// Going to pretty much copy the end-user signup form.
		$elements = [];
		$elements[] = ['type' => 'input', 'var' => 'user_name', 'text' => 'Full Name:', 'comment' => 'Main contact for account'];
		$elements[] = ['type' => 'input', 'var' => 'user_email', 'text' => 'E-mail Address:', 'comment' => 'Also your login to this system'];
		$elements[] = ['type' => 'password', 'var' => 'user_password', 'text' => 'Password:'];
		$elements[] = ['type' => 'input', 'var' => 'user_phone', 'text' => 'Phone Number (and Extension):', 'comment' => 'xxx.xxx.xxxx ext. xxx'];
		$elements[] = ['type' => 'input', 'var' => 'user_title', 'text' => 'Title:', 'comment' => 'Leave blank if individual'];
		$span = [];
		$span[] = ['span' => 6, 'elements' => $elements];
		$elements = [];
		$elements[] = ['type' => 'input', 'var' => 'company_name', 'text' => 'Company Name:', 'comment' => 'If individual leave this blank'];
		$elements[] = ['type' => 'input', 'var' => 'company_address', 'text' => 'Address:', 'comment' => 'Where to mail invoices if required?'];
		$elements[] = ['type' => 'input', 'var' => 'company_address2', 'text' => 'Address Line 2:', 'comment' => 'Suite, etc.'];
		$elements[] = ['type' => 'input', 'var' => 'company_city', 'text' => 'City:'];
		$elements[] = ['type' => 'input', 'var' => 'company_state', 'text' => 'State:', 'class' => 'state'];
		$elements[] = ['type' => 'input', 'var' => 'company_zip', 'text' => 'Zip:'];
		$span[] = ['span' => 6, 'elements' => $elements];
		$form = form::init()->spanElements($span)->id('createAccount')->post('/clients/')->render();
		$button = button::init()->formid('createAccount')->text('Create New Account')->addStyle('post')->addStyle('btn-primary')->icon('fire')->message('Creating Account..')->postVar('createAccount')->render();
		$save = "<div class='pull-right'>$button</div>";
		$data .= widget::init()->icon('share-alt')->span(12)->header('Account Details')->content($form)->footer($save)->render();
		$this->exportJS(js::maskInput('state', "**"));
		$this->export($data);
	}

	public function createAccount($content)
	{
		$exists = $this->returnCountFromTable("users", "user_email='$content[user_email]'");
		if ($exists > 0)
			$this->failJson('Unable to Create Account', 'Account already exists.');
		if ($content['company_name'])
		{
			$exists = $this->returnCountFromTable("companies", "company_name='$content[company_name]'");
			if ($exists > 0)
				$this->failJson('Unable to Create Account', 'Company already exists.');
		}
		if (!$content['user_name'] || !$content['user_email'] || !$content['user_password'])
			$this->failJson("Unable to Create Account", "You must fill in all appropriate fields.");
		$password = md5($content['user_password']);
		$this->query("INSERT into users SET user_name='$content[user_name]', user_password='$password', user_email='$content[user_email]',
				user_phone='$content[user_phone]', user_title='$content[user_title]'");
		$uid = $this->insert_id;
		if (!$content['company_name'])
			$content['company_name'] = $content['user_name'];
		$now = time();
		$this->query("INSERT into companies SET company_since='$now', company_phone='$content[user_phone]', company_name='$content[company_name]', company_address='$content[company_address]', company_address2='$content[company_address2]',
				company_city='$content[company_city]', company_state='$content[company_state]', company_zip='$content[company_zip]', company_admin='$uid'");
		$cid = $this->insert_id;
		$this->query("UPDATE users SET company_id='$cid' WHERE id='$uid'"); // Assign the company to that user.


		// In the admin side we want to notify customers they have an account vs on the login
		// page where we just notified the company.
		$weare = $this->getSetting("mycompany");
		$url = $this->getSetting("atikit_url");
		$defaultEmail = $this->getSetting("defaultEmail");
		$this->mailCompany($cid, "New Account Created with {$weare}",
"This email is to inform you that you have been created a new account on the support system, aTikit, currently used by {$weare}. Here are the details to your new account!

URL/Link: $url
E-mail Address: $content[user_email]
Password: $content[user_password]

You can login and change your password by going to the options menu and clicking My Profile.
If you have any questions please feel free to email $defaultEmail");

		$json = [];
		$json['gtitle'] = 'Account Created';
		$json['gbody'] = 'New Client Account has been created.';
		$json['action'] = 'reload';
		$json['url'] = '/clients/';
		$this->jsone('success', $json);
	}

	private function getQTotals(&$transactions)
	{
		$result = [];
		for ($i=0; $i<=2; $i++)
		{
			if ($i == 0)
			{
				$sts = strtotime(date("F"). " 1");	//Should be start of this month. Translates "Februrary 1";
				$month = date("m", $sts);
				$year = date("y", $sts);
				$num = cal_days_in_month(CAL_GREGORIAN, $month, $year)-1;
				$ets = ($sts + ($num * 86400)); // 1 second behind how many days in that month times seconds in a day..
			}
			else
			{
				$sts = strtotime("-{$i} months"); // Gives a ts for X months from today.. what month is that?
				$month = date("m", $sts);
				$year = date("y", $sts);
				$num = cal_days_in_month(CAL_GREGORIAN, $month, $year);
				$sts = strtotime($month . "/" . '1'. "/" . $year);
				$ets = ($sts + ($num * 86400))-1; // 1 second behind how many days in that month times seconds in a day..
			}
			$result[$i] = 0;
			foreach($transactions AS $transaction)
				if ($transaction['transaction_ts'] > $sts AND $transaction['transaction_ts'] < $ets)
					$result[$i] += $transaction['transaction_amount'];
		}
		return $result;
	}

	public function listClients()
	{
		// Subscription, 3 Months ago, 2 months ago, this month, total
		$headers = [null, "Client", "VIP", "Tickets"];
		$month3 = date("F", strtotime("-2 Months")); // Don't hate.
		$month2 = date("F", strtotime("-1 Months")); // I know this is dumb.
		$thisMonth = date("F");
		$totals = [];
		if ($this->canSeeBilling())
		{
			$billing = ['Subscription', $month3, $month2, $thisMonth, 'Total Income'];
			$headers = array_merge($headers, $billing);
		}
		$rows = [];
		$companies = $this->query("SELECT * from companies WHERE company_isprovider = false ORDER by company_since DESC");
		foreach ($companies AS $company)
		{
			$tcontent = null;
			$ticks = $this->query("SELECT id,ticket_title FROM tickets WHERE company_id='$company[id]' ORDER by ticket_opents DESC LIMIT 10");
			foreach ($ticks AS $tick)
				$tcontent .= "<a href='/ticket/$tick[id]/'>$tick[ticket_title]</a><br/>";
			$ticketblock = base::popover("Ticket History", $tcontent, 'right');
			$row = ["<img width='20px' height='20px' src='/".$this->getProfilePicFromCID($company['id'])."'>", "<a href='/client/$company[id]/'>$company[company_name]</a>",
					($company['company_vip']) ? "Yes" : "No",
					"<a href='#' $ticketblock>".$this->returnCountFromTable("tickets", "company_id='$company[id]'")."</a>"

			];
			if ($this->canSeeBilling())
			{
				$plan = $this->query("SELECT * from plans WHERE id='$company[company_plan]'", true)[0];
				if (!$plan)
					$plandata = "No Subscription";
				else
					$plandata = "$plan[plan_name] ($".number_format($plan['plan_amount'],2).")";

				$ttl = 0;
				$transactions = $this->query("SELECT transaction_ts,transaction_amount FROM transactions WHERE company_id='$company[id]'");
				foreach ($transactions AS $transaction)
					$ttl += $transaction['transaction_amount'];
				$totals[3] += $ttl;
				$ttl = "$" . number_format($ttl,2);
				$m = $this->getQTotals($transactions);
				$new = [$plandata, "$".number_format($m[2],2), "$".number_format($m[1],2), "$".number_format($m[0],2), $ttl];
				$row = array_merge($row, $new);
				$totals[0] += $m[0];
				$totals[1] += $m[1];
				$totals[2] += $m[2];

 			}
			$rows[] = $row;
		}
		if ($this->canSeeBilling())
			$rows[] = [null, null, null, null, "<span class='pull-right'><b>Totals:</b></span>",
				"$". number_format($totals[2],2),
				"$". number_format($totals[1],2),
				"$". number_format($totals[0],2),
				"$". number_format($totals[3],2),
				'green'

				];
		$this->exportJS(js::datatable('clientList'));
		$addButton = button::init()->text("Add Account")->icon('plus')->addStyle('btn-success')->url('/clients/create/')->render();
		$table = table::init()->headers($headers)->rows($rows)->id('clientList')->render();
		$widget = widget::init()->header("Customer List")->content($table)->isTable()->icon('user')->rightHeader($addButton)->render();
		$this->export(base::row($widget));

	}

	public function showClient($content)
	{
		$id = $content['showClient'];
		$company = $this->query("SELECT * from companies WHERE id='$id'")[0];
		$user = $this->query("SELECT * from users WHERE company_id='$company[id]'")[0];
		// Going to pretty much copy the end-user signup form. (and change our postvars)
		$pic = $this->getProfilePic($user['id']);
		$elements = [];
		$elements[] = ['type' => 'input', 'var' => 'user_name', 'text' => 'Full Name:', 'comment' => 'Main contact for account', 'val' => $user['user_name']];
		$elements[] = ['type' => 'input', 'var' => 'user_email', 'text' => 'E-mail Address:', 'comment' => 'Also your login to this system', 'val' => $user['user_email']];
		$elements[] = ['type' => 'password', 'var' => 'user_password', 'text' => 'Password:'];
		$elements[] = ['type' => 'input', 'var' => 'user_phone', 'text' => 'Phone Number (and Extension):', 'comment' => 'xxx.xxx.xxxx ext. xxx', 'val' => $user['user_phone']];
		$elements[] = ['type' => 'input', 'var' => 'user_title', 'text' => 'Title:', 'comment' => 'Leave blank if individual', 'val' => $user['user_title']];
		$span = [];
		$span[] = ['span' => 4, 'elements' => $elements];
		$elements = [];
		$elements[] = ['type' => 'input', 'var' => 'company_name', 'text' => 'Company Name:', 'comment' => 'If individual leave this blank', 'val' => $company['company_name']];
		$elements[] = ['type' => 'input', 'var' => 'company_address', 'text' => 'Address:', 'comment' => 'Where to mail invoices if required?', 'val' => $company['company_address']];
		$elements[] = ['type' => 'input', 'var' => 'company_address2', 'text' => 'Address Line 2:', 'comment' => 'Suite, etc.', 'val' => $company['company_address2']];
		$elements[] = ['type' => 'input', 'var' => 'company_city', 'text' => 'City:', 'val' => $company['company_city']];
		$elements[] = ['type' => 'input', 'var' => 'company_state', 'text' => 'State:', 'class' => 'state', 'val' => $company['company_state']];
		$elements[] = ['type' => 'input', 'var' => 'company_zip', 'text' => 'Zip:', 'val' => $company['company_zip']];
		$span[] = ['span' => 4, 'elements' => $elements];
		$elements = [];
		$elements[] = ['type' => 'textarea', 'rows'=> 15, 'var' => 'company_notes', 'text' => 'Company Notes:', 'val' => $company['company_notes']];
		$checked = ($company['company_vip']) ? true : false;
		$opts = [['val' => 'Y', 'text' => 'Company is VIP?', 'checked' => $checked]];
		$elements[] = ['type' => 'checkbox', 'var' => 'company_vip', 'opts' => $opts];
		$elements[] = ['type' => 'ajax', 'id' => 'logoUpload', 'text' => "Company Logo:<br/><img src='/$pic'>"];
		$span[] = ['span' => 4, 'elements' => $elements];

		$form = form::init()->spanElements($span)->id('editAccount')->post('/clients/')->render();
		$button = button::init()->formid('editAccount')->text('Edit Account')->addStyle('post')->addStyle('btn-primary')->icon('fire')->message('Modifying Account..')->postVar('editAccount')->id($company['id'])->render();
		$save = "<div class='pull-right'>$button</div>";
		$data .= widget::init()->icon('share-alt')->span(12)->header('Account Details')->content($form)->footer($save)->render();
		$this->exportJS(js::maskInput('state', "**"));
		$this->exportJS(js::ajaxFile('logoUpload', "logo_$id"));
		$this->export($data);
	}

	public function editClient($content)
	{
		$id = $content['editAccount'];
		$checked = ($content['company_vip'] == 'Y') ? 'true' : 'false';
		$uid = $this->returnFieldFromTable("id", "users", "company_id='$id'");
		$this->query("UPDATE users SET user_name='$content[user_name]', user_email='$content[user_email]', user_phone='$content[user_phone]',
				user_title='$content[user_title]' WHERE id='$uid'");

		$this->query("UPDATE companies SET company_phone='$content[user_phone]', company_notes='$content[company_notes]', company_vip=$checked, company_name='$content[company_name]', company_address='$content[company_address]', company_address2='$content[company_address2]',
				company_city='$content[company_city]', company_state='$content[company_state]', company_zip='$content[company_zip]' WHERE id='$id'");
		$json = [];
		$json['action'] = 'reload';
		$json['url'] = '/clients/';
		$this->jsonE('success', $json);
	}
}

$mod = new clients();
if (isset($_GET['createClient']))
	$mod->createClient();
else if (isset($_POST['createAccount']))
	$mod->createAccount($_POST);
else if (isset($_GET['showClient']))
	$mod->showClient($_GET);
else if (isset($_POST['editAccount']))
	$mod->editClient($_POST);

else
	$mod->main();
