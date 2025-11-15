# **PortaCode Classroom Workshops**

*(Turn any PC into a full coding lab — even for students on phones.)*

PortaCode lets students code from **any device**—smartphones, tablets, Chromebooks, whatever they have.
You run a single machine with Docker, and PortaCode gives each student their own isolated development environment with:

* a terminal
* a VS-Code–like editor
* an integrated AI assistant
* File explorer with version control

---

# **Two ways to set up your workshop**

This repository offers two ready-to-use setups:

1. **Quick & Easy** → `temporary_workspace/`
2. **Persistent & Protected** → `persistent_workspace/`

Both methods use the same simple PortaCode flow:

1. Open your PortaCode dashboard
2. Click **“Pair Device”**
3. Enter the temporary pairing code into the machine
4. Approve the pairing request on the dashboard
5. Transfer each device to a student’s email (so only they can access it)


Below is the difference between the two setups.

---

## **1) Quick & Easy (temporary)**

**Folder:** [`temporary_workspace/`](temporary_workspace/)

* Requires only Docker + Docker Compose
* One command and all student containers start
* Perfect for fast workshops or one-off events

**BUT:**

* Student files stay inside containers (easy to lose since anything that recreates the container deletes everything inside the container)
* No disk-space limits → Although one student cannot access anybody else's files, one student can still fill up the disk for everyone

---

## **2) Persistent & Protected**

**Folder:** [`persistent_workspace/`](persistent_workspace/)

* Each student gets their own **persistent folder** on the host
* Their work survives restarts and is eaily accessible by the teacher without having to attach to the container

**BUT:**

* Requires a slightly more advanced setup and might be slightly harder to manage

---

## **Which one should you choose?**

| Setup                      | Best For                           | Pros                       | Cons                           |
| -------------------------- | ---------------------------------- | -------------------------- | ------------------------------ |
| **Quick & Easy**           | Short workshops, beginners         | Fast, simple               | No persistence, no disk limits |
| **Persistent & Protected** | Longer classes, repeated workshops | Safe, reliable, persistent | Slightly more setup            |

---

## **Next steps**

* Go to **[`temporary_workspace/`](temporary_workspace/)** for the Quick & Easy version
* Go to **[`persistent_workspace/`](persistent_workspace/)** for the Persistent & Protected setup

